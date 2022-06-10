import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/TabsScreen.dart';
import './auth_page.dart';

import "../services/checkLogin.dart"; // '../screens/home/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TabScreen(); // tjekker om korrekt login er givet. Hvis ikke, så viser den login side.
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
