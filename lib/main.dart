import 'package:flutter/material.dart';
import 'package:login_page/screens/ApartmentScreen.dart';
import 'package:login_page/screens/StartScreen2.dart';
import 'package:login_page/screens/StartScreen3.dart';
import './services/checkLogin.dart';
import 'package:login_page/screens/TabsScreen.dart';
import 'package:login_page/services/checkLogin.dart';
import './screens/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import "./screens/ProfileApartment.dart";
import "./screens/ProfileScreen.dart";
import "./screens/SearchScreen.dart";
import "./screens/FavoritesScreen.dart";
import "./screens/ChatScreen.dart";
import "./screens/FailScreen.dart";
import "./screens/StartScreen.dart";

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
      
      // routes: {
      //   '/apartment-screen':(context) => ApartmentScreen()
      // },
      debugShowCheckedModeBanner: false,
      // home: checkLogin(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) =>  StartScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        checkLogin.routeName:(context) => checkLogin(),
        ProfileApartment.routeName: (context) => const ProfileApartment(),
        ChatScreen.routeName: (context) => ChatScreen(),
        FavoritesScreen.routeName: (context) => FavoritesScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        SearchScreen.routeName: (context) => SearchScreen(),
        FailScreen.routeName: (context) => FailScreen(),
        ApartmentScreen.routeName: (context) => ApartmentScreen(),
        StartScreen2.routeName: (context) => StartScreen2(),
        StartScreen3.routeName: (context) => StartScreen3(),
      },
    );
  }
}
