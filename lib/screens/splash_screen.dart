import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_final/components/components.dart';

import '../cashe_helper/cashe_helper.dart';
import '../layout/layout_for_client.dart';
import '../layout/layout_for_drivers.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    startTimer();
  }

  startTimer(){
    Timer timer = Timer(
      Duration(seconds: 5),
          () {
        CasheHelper.GetData(key: 'uId') != null
            ? CasheHelper.GetData(key: 'isDriver')
            ? navigateAndFinish(screen: LayoutForDrivers(), context: context)
            : navigateAndFinish(screen: LayoutForClient(), context: context)
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
