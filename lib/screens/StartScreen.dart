import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'StartScreen2.dart';

class StartScreen extends StatefulWidget {
  static const routeName = "/Start-Screen"; 

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 

    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 32, 40, 35),
            Color.fromARGB(255, 26, 51, 76)
          ],
        ),
      ),
      child: Scaffold(
        
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 250,),
            Text("StudentSwap",
          style: TextStyle(color: Colors.white, 
          fontSize: 50,
          fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15,),
          Text("Worry less on accomendation, and focus more on study",
          style: TextStyle(color: Colors.white, fontSize: 15),),
          SizedBox(height: 45,),
          Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, StartScreen2.routeName);
                      },
                      child: Center(
                        child: Container(
                          width: screenWidth/3,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'EXPLORE',
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
      )
    );
  }
}
