// import 'package:flutter/material.dart';
// import "../screens/login/login_page.dart"; // package:login_page/pages/login_page.dart';
// import "../screens/login/register_page.dart";
// import "../screens/login/register_page2.dart";

// class AuthPage extends StatefulWidget {
//   const AuthPage({Key? key}) : super(key: key);

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   // initially, show the login page
//   int showLoginPage = 0;
//   int showRegisterPage = 0;
//   int showRegisterPage2 = 0;

//   void toggleScreens() {
//     setState(() {
//       showLoginPage++;
//       showRegisterPage++;
//       showRegisterPage2++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showLoginPage == 0) {
//       return LoginPage(showRegisterPage: toggleScreens);
//     }
//     return Text(("hello if statemaent ehere"));
//     // } else if (showRegisterPage == 1) {
//     //   return RegisterPage(showLoginPage: toggleScreens);
//     // } else if (showRegisterPage2 == 2) {
//     //   return RegisterPage2(showRegisterPage: toggleScreens);
//     // } else {
//     //   return RegisterPage(showLoginPage: toggleScreens);
//     // }
//   }
// }
