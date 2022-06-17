//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page/services/checkLogin.dart';

class StartScreen3 extends StatelessWidget {
  static const routeName = "/Start-Screen3"; 

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 26, 51, 76),)
          ,backgroundColor: Colors.transparent
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Save time & hazzle",
            style: TextStyle(color: Colors.black, 
            fontSize: 40, fontWeight: FontWeight.bold),),
      
            SizedBox(height: 20,),
            Text("Worry less about your accomendation,",
            style: TextStyle(color: Colors.grey[700], fontSize: 15),),
            SizedBox(height: 5,),
            Text("and focus on your studies",
            style: TextStyle(color: Colors.grey[700], fontSize: 15),),
            SizedBox(height: 100,),
            Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, checkLogin.routeName);
                      },
                      child: Center(
                        child: Container(
                          width: screenWidth/3,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:  Color.fromARGB(255, 26, 51, 76),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'GO TO LOGIN',
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