import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/screens/StartScreen.dart';
import '../screens/TabsScreen.dart';
import '../screens/login/login_page.dart';
import '../screens/login/register_page2.dart';
import './auth_page.dart';

import "../services/checkLogin.dart"; // '../screens/home/home_page.dart';

class checkLogin extends StatelessWidget {
  static const routeName = "/Check-Login";
  const checkLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TabScreen(); // tjekker om korrekt login er givet. Hvis ikke, så viser den login side.
          } else {
            return StartScreen();
          }
        },
      ),
    );
  }
}
