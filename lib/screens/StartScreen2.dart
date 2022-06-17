//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page/screens/StartScreen3.dart';

class StartScreen2 extends StatelessWidget {
  static const routeName = "/Start-Screen2"; 

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 26, 51, 76),),
          backgroundColor: Colors.transparent,

        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Swap your home with",
            style: TextStyle(color: Colors.black, 
            fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 1,),
            Text("another student",
            style: TextStyle(color: Colors.black, 
            fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text("Find a accomendation match, and swap",
            style: TextStyle(color: Colors.grey[700], fontSize: 15),),
            SizedBox(height: 5,),
            Text("your home while during erasmus",
            style: TextStyle(color: Colors.grey[700], fontSize: 15),),
            SizedBox(height: 100,),
            Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, StartScreen3.routeName);
                      },
                      child: Center(
                        child: Container(
                          width: screenWidth/3,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 26, 51, 76),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'NEXT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
            ],
            ),
        ),
      );
  }
}