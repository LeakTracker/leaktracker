import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:water_loss_project/home.dart';
import 'package:water_loss_project/screens/dashboard_screen.dart';
import 'package:water_loss_project/screens/splash_screen.dart';
import 'package:water_loss_project/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  signInWithEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashPage()),
          (route) => false);
    } on auth.FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        showTopSnackBar(
          context,
          const CustomSnackBar.error(message: "No user found"),
        );
      } else if (e.code == 'wrong-password') {
        showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "Wrong Email or Password",
          ),
        );
      }
    }
  }

  getUserInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    }
  }

  @override
  void initState() {
    // getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/leaktracker.png",
                    height: 100.0,
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      signInWithEmail();
                    },
                    child: DefaultButton(
                      title: "Login",
                      loading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
