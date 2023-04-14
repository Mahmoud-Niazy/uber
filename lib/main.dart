import 'package:firebase_core/firebase_core.dart';
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
  await Firebase.initializeApp();
  await CasheHelper.Init();
  DioHelper.Init();
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
          create: (context) => UberCubit()..GetUserData(
            userId:CasheHelper.GetData(key: 'uId')  ,
          )..GetClientLocation()..GetClientOrders()..GetAllOrders()..GetAcceptedOrders(),
        ),
      ],
      child: MaterialApp(
        home: CasheHelper.GetData(key: 'uId') != null ? CasheHelper.GetData(key: 'isDriver') ? LayoutForDrivers() :  LayoutForClient() : LoginScreen(),
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


