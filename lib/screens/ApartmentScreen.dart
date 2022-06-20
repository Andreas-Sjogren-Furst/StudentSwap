// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_page/screens/ChatScreen.dart';
import 'package:login_page/services/FirebaseMethods.dart';
import 'package:login_page/widgets/Apartment.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'IndividualChatPage.dart';
import 'ProfileApartment.dart';
import 'SearchScreen.dart';
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

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
    String currentUserName = args['currentUser'];

    //String listeAfDestinationer = goingTo.map((g) => g.toString()).toString();

    String listeAfDestinationer(List<dynamic> value) {
      String output = '';
      value.forEach((x) => x.toString());
      output = value.join(', ');
      return output;
    }

    // apartmentImage's kan hentes fra firebase?
    // hvis ja kan man lave et array med alle apartment billederne.

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

          String firstName = userDocument['firstName'];
          String lastName = userDocument['lastName'];
          List<dynamic> additionalImages = userDocument['additionalImages'];

          print(firstName);
          print(lastName);
          print(additionalImages);
          var additionalPhotoRef = FirebaseStorage.instance
              .ref()
              .child("user_images")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child("additional_photos");

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
                    backgroundImage: NetworkImage(profileImage),
                    radius: 52,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  '$firstName $lastName',
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                screenWidth / 30,
                                screenHeight / 40,
                                screenWidth / 30,
                                screenHeight / 40),
                            primary: Colors.white,
                            textStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        label: Text('Chat'),
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          String _shaKey = FirebaseMethods.updateUserChats(
                              currentUserId, userID);
                          print("userids: $currentUserId + $userID");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (IndividualChatpage(
                                        shaKey: _shaKey,
                                        counterUserName: firstName,
                                        currentUserName: currentUserName,
                                      ))));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              
              Expanded(
                flex: 1,
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 244, 244),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.topLeft,
                          height: screenHeight / 5,
                          width: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    oneOrMore(goingTo),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    listeAfDestinationer(goingTo),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'From',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '$city',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 244, 244),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.topCenter,
                          height: screenHeight / 5,
                          width: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                      ),
                    ),
                  ]),
                )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(19, 0, 8, 8),
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
                  itemCount: additionalImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    height: screenHeight * 0.7,
                                    width: screenWidth * 0.7,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              additionalImages[index]),
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                ),
                              );

                              setState(() {
                                // Used for updating user-actions
                              });
                            },
                            child: Image(
                              image: NetworkImage(additionalImages[index]),
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
  }
}
