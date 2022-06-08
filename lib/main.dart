import 'package:flutter/material.dart';
import './screens/FavoritesScreen.dart';
import './screens/TabsScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DeliMeals',

        // Dette er vores theme.
        theme: ThemeData(
          canvasColor: Color.fromRGBO(229, 229, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headline6: TextStyle(
                fontSize: 24,
                fontFamily: 'RobotoCondensed',
              ),
              headline1: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              )),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.amber),
        ),
        routes: {
          '/': (ctx) => TabScreen(), // tab screen is the main screen.
          FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
        });
  }
}
