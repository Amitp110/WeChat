import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wechat/screens/home.dart';
import 'package:wechat/screens/login.dart';
import 'package:wechat/shared/sharedpref.dart';
import 'package:wechat/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3;

  bool _isLogin = false;
  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/signup.png",
            height: height - 50,
            width: width - 20,
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                child: const Text(
                  "Chat with your favourite person with Wechat.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ColorTheme.primaryBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _loadWidget() async {
    await SharedPref.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isLogin = value;
        setState(() {});
      }
    });

    var duration = Duration(seconds: splashDelay);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    log("\n ********* ISLOGIN $_isLogin **********\n");

    if (_isLogin) {
      homePage();
    } else {
      loginPage();
    }
  }

  void loginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const Login(),
      ),
    );
  }

  void homePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const Home(),
      ),
    );
  }
}
