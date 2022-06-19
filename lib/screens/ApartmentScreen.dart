// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_page/services/FirebaseMethods.dart';
import 'package:login_page/widgets/Apartment.dart';
import 'dart:convert';

class ApartmentScreen extends StatefulWidget {
  static const routeName = "/apartment-screen";

  const ApartmentScreen({Key? key}) : super(key: key);

  @override
  State<ApartmentScreen> createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {
  String oneOrMore(List<dynamic> destinationer) {
    return destinationer.length > 1 ? 'Destinations' : 'Destination';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String apartmentImage = args['apartmentImage'] ?? 'not available';
    String city = args['city'] ?? 'not available';
    String address = args['address'] ?? 'not available';
    String profileImage = args['profileImage'] ?? 'not available';
    String userID = args['userID'] ?? 'not available';
    bool savedFavorite = args['savedFavorite'] != null;
    List<dynamic> goingTo = args['goingTo'];

    //String listeAfDestinationer = goingTo.map((g) => g.toString()).toString();

    String listeAfDestinationer(List<dynamic> value) {
      String output = '';
      value.forEach((x) => x.toString());
      output = value.join(', ');
      return output;
    }

    // apartmentImage's kan hentes fra firebase?
    // hvis ja kan man lave et array med alle apartment billederne.

    var lejlighedsPics = [
      'assets/sample/apartment1.jpg',
      'assets/sample/apartment2.jpg',
      'assets/sample/apartment1.jpg',
      'assets/sample/apartment2.jpg'
    ];

    // ovenstående liste skal på en eller anden måde initialiseres fra firebase.

    // vi skal også bruge info om hvor vedkommende skal hen ogh kommer fra - VIGTIGT

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Object? userDocument = snapshot.data!.data();
          userDocument = userDocument as Map<String, dynamic>;
          print(userDocument["firstName"]);
          print(userDocument["appartmentImages"]);

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Column(children: [
              SizedBox(
                height: 45,
              ),
              Center(
                child: Container(
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/sample/$profileImage.jpg'),
                    radius: 52,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "$userID",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "$address, $city",
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    shape: const CircleBorder(),
                    color: Colors.blue,
                    padding: const EdgeInsets.all(20),
                    onPressed: () {
                      FirebaseMethods.updateUserChats(
                          FirebaseMethods.userId, userID);
                    },
                    child: const Icon(
                      Icons.email,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    color: Colors.blue,
                    padding: const EdgeInsets.all(20),
                    onPressed: () {},
                    child: const Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(19, 8, 8, 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Information",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    width: screenWidth - 38,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                        child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.topLeft,
                            height: screenHeight / 5,
                            width: 20,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "From",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '$city blabla blabla bla bla',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: screenHeight / 5,
                            width: 20,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Jeg hedder johnson og er fra nor available, jeg er sød og imødekommende og lugter en smule af ost. Jeg træner meget og holder meget af fodbold samt cykling",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ))),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(19, 8, 8, 8),
                  child: Text(
                    "Pictures",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: lejlighedsPics.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            child: Image(
                              image: AssetImage(lejlighedsPics[index]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
          );
        });

    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('$address, $city'),
    //   ),
    //   body: Container(
    //       child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           MaterialButton(
    //             shape: const CircleBorder(),
    //             color: Colors.blue,
    //             padding: const EdgeInsets.all(20),
    //             onPressed: () {},
    //             child: const Icon(
    //               Icons.email,
    //               size: 50,
    //               color: Colors.white,
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
    //             child: Align(
    //               alignment: Alignment.topCenter,
    //               child: CircleAvatar(
    //                 backgroundImage:
    //                     AssetImage('assets/sample/$profileImage.jpg'),
    //                 radius: 100,
    //               ),
    //             ),
    //           ),
    //           MaterialButton(
    //             shape: const CircleBorder(),
    //             color: Colors.blue,
    //             padding: const EdgeInsets.all(20),
    //             onPressed: () {},
    //             child: const Icon(
    //               Icons.favorite,
    //               size: 50,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ],
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       // ignore: prefer_const_constructors
    //       Text(
    //         "$userID", // tilføj et brugernavn/rigtigt navn/userID?
    //         style: TextStyle(
    //             color: Colors.black, fontSize: 30.0, fontFamily: "Poppins"),
    //       ),

    //       Container(
    //         width: 300,
    //         height: 50,
    //        child: Text("aaaaaaaaaadlæk apfnvouhnrpcuhgpoi wuåotignqpexirmghpehqpsiuh,dcfoxisaheiruzg,vmpixueqrhmgxpis,uhepogicfhmaepmxohrbpiuhergpcohmxaprieughmzp,aehrxvpiuqehr,iuqhe,"

    //        )

    //       ),

    //       Divider(
    //         indent: 30,
    //         endIndent: 30,
    //         color: Colors.grey,
    //         thickness: 2,
    //       ),

    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
    //         child: Container(
    //           child: Align(
    //             alignment: Alignment.topLeft,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Column(
    //                   children: [
    //                     Text(
    //                       "From",
    //                       style: TextStyle(
    //                         fontSize: 30,
    //                         fontFamily: 'Poppins',
    //                       ),
    //                     ),
    //                     Text(city)
    //                   ],
    //                 ),
    //                 Column(
    //                   children: [
    //                     Text(
    //                       oneOrMore(goingTo),
    //                       style: TextStyle(
    //                         fontSize: 30,
    //                         fontFamily: 'Poppins',
    //                       ),
    //                     ),
    //                     Text(listeAfDestinationer(goingTo))
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //           child: ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         physics: const ClampingScrollPhysics(),
    //         itemCount: lejlighedsPics.length,
    //         itemBuilder: (context, index) {
    //           return Padding(
    //             padding: const EdgeInsets.all(12),
    //             child: Card(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12.0),
    //               ),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(10),
    //                 child: InkWell(
    //                   child: Image(
    //                     image: AssetImage(lejlighedsPics[index]),
    //                     fit: BoxFit.contain,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           );
    //         },
    //       )),
    //     ],
    //   )),
    // );
  }
}
