import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import '../cashe_helper/cashe_helper.dart';
import '../layout/layout_for_client.dart';
import '../layout/layout_for_drivers.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EasySplashScreen(
        logoWidth: MediaQuery.of(context).size.width/2,
        logo: Image.asset(
          'assets/images/City driver.gif',
        ),
        navigator: CasheHelper.GetData(key: 'uId') != null
            ? CasheHelper.GetData(key: 'isDriver')
            ? LayoutForDrivers()
            : LayoutForClient()
            : LoginScreen(),
        durationInSeconds: 2,
        showLoader: false,
      ),
    );
  }
}
