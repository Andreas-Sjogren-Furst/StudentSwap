import 'package:flutter/material.dart';
import 'package:login_page/screens/FavoritesScreen.dart';
import 'package:login_page/screens/ProfileScreen.dart';
import './services/checkLogin.dart';
import 'package:login_page/screens/TabsScreen.dart';
import 'package:login_page/services/checkLogin.dart';
import './screens/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      //routes: {
      //  '/': (ctx) => TabScreen(),
      //ProfileScreen.routeName: (ctx) => ProfileScreen(),
      //FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
      //}
    );
  }
}
