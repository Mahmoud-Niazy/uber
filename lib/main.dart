import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';
import 'package:uber_final/dio_helper/dio_helper.dart';
import 'package:uber_final/layout/layout_for_drivers.dart';
import 'package:uber_final/register_cubit/register_cubit.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import 'layout/layout_for_client.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    // 'resource://mipmap-xxxhdpi/ic_launcher.png',
    null,
    [
      NotificationChannel(
        channelKey: 'Firebase',
        channelName: 'Firebase',
        channelDescription: 'Fcm from Firebase',
        playSound: true,
        channelShowBadge: true,
      ),
    ],
  );
  await Firebase.initializeApp();
  await CasheHelper.Init();
  DioHelper.Init();

  FirebaseMessaging.onMessage.listen((event) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 5,
        channelKey: 'Firebase',
        title: event.notification!.title,
        body: event.notification!.body,
      ),
    );
    print('Notification');
  });
  // FirebaseMessaging.onBackgroundMessage((message) {
  //   return AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 5,
  //       channelKey: 'Firebase',
  //       title: 'Notification from Firebase',
  //       body: 'Notification from Firebase',
  //       bigPicture: 'assets/images/33088-1-taxi-driver-file.png',
  //     ),
  //   );
  //   print('Notification');
  //
  // });

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  runApp(MyApp());

  print(CasheHelper.GetData(key: 'isDriver'));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => UberCubit()
            ..GetUserData(
              userId: CasheHelper.GetData(key: 'uId'),
            )
            ..GetUserLocation()
            ..GetClientOrders()
            ..GetAllOrders()
            ..GetAcceptedOrders(),
        ),
      ],
      child: MaterialApp(
        home: CasheHelper.GetData(key: 'uId') != null
            ? CasheHelper.GetData(key: 'isDriver')
                ? LayoutForDrivers()
                : LayoutForClient()
            : LoginScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
