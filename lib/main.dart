import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        fontFamily: 'Quicksand',
      ),
      home: SplashPage(),
    );
  }
}
