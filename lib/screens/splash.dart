import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      var user = await SharedPreferenceUtil().getUserDetails();
      String routeName;
      if (user?.token != null && user!.token!.trim().isNotEmpty) {
        routeName = "/home";
        // routeName = "/vendordetails";
      } else {
        routeName = "/login";
      }
      Navigator.of(context).pushReplacementNamed(routeName);
    });
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/logo/autoclinch_logo.png',
            height: 100,
            //cacheHeight: 60,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
