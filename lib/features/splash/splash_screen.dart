import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/cashe_helper/cashe_helper.dart';
import '../../core/functions/functions.dart';
import '../layout/layout_for_client.dart';
import '../layout/layout_for_drivers.dart';
import '../login/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer(){
    Timer timer = Timer(
      const Duration(seconds: 5),
          () {
        CasheHelper.getData(key: 'uId') != null
            ? CasheHelper.getData(key: 'isDriver')
            ? navigateAndFinish(screen: const LayoutForDrivers(), context: context)
            : navigateAndFinish(screen: const LayoutForClient(), context: context)
            :navigateAndFinish(screen: LoginScreen(), context: context) ;

      },
    );
    return timer ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Lottie.asset('assets/lottie/data.json')),
      // EasySplashScreen(
      //   logoWidth: MediaQuery.of(context).size.width/2,
      //   logo:
      //   Image.asset(
      //     'assets/images/City driver.gif',
      //   ),
      //   navigator: CasheHelper.GetData(key: 'uId') != null
      //       ? CasheHelper.GetData(key: 'isDriver')
      //       ? LayoutForDrivers()
      //       : LayoutForClient()
      //       : LoginScreen(),
      //   durationInSeconds: 2,
      //   showLoader: false,
      // ),
    );
  }
}
