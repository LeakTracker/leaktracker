import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/screens/login_screen.dart';
import 'package:water_loss_project/widgets/button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
      debugPrint("signOut() -> success");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: COLOR_GREEN, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const SizedBox(height: 30.0),
          GestureDetector(
            onTap: () {
              signOut();
            },
            child: const DefaultButton(
              title: "logout",
              loading: false,
            ),
          )
        ],
      ),
    );
  }
}
