import 'dart:async';
import 'package:water_loss_project/api/user_api.dart';
import 'package:water_loss_project/constant/global.dart' as global;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/home.dart';
import 'package:water_loss_project/screens/create_report.dart';
import 'package:water_loss_project/screens/dashboard_screen.dart';
import 'package:water_loss_project/screens/login_screen.dart';
import 'package:water_loss_project/screens/maintenance/reports_maintenance_screen.dart';

class SplashPage extends StatefulWidget {
  static const String id = 'splashScreen';

  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String email = "";
  final UserApi _userApi = UserApi();

  navigateToLandingPage() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, nextPage);
  }

  void nextPage() async {
    if (email != "") {
      global.user = await _userApi.getUserInfo();
      if (global.user.userType == "user") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ReportsMaintenanceScreen()));
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             email == "" ? const LoginScreen() : const HomeScreen()));
  }

  getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      global.user_email = email;
      global.user = await _userApi.getUserInfo();
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    navigateToLandingPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_LIGHT_GREEN,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballPulseSync,
                colors: [Colors.red, Colors.amber, Colors.green],
                strokeWidth: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
