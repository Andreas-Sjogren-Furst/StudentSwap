import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/widgets/Apartment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = "/Favorites-Screen";

  final uid = FirebaseAuth.instance.currentUser!.uid;

  final FirestoreUserReference = FirebaseFirestore.instance.collection("users");

  getData() async {
    //Metode som henter favorit-array for current-user
    var userDocument = await FirestoreUserReference.doc(uid).get();
    return await userDocument['favorites'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            //Steambuilder der lavet et snapshot for alle users
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SpinKitFadingCube(
                    color: Colors.blue,
                    size: 80,
                  ),
                );
              }

              List<Apartment> apartmentsLists = [];
              List<Apartment> apartments = [];
              List<dynamic> favoriteUser = [];

              var currentUserFavorties = [];

              snapshot.data!.docs.forEach((doc) {
                //laver foor-loop for at finde users favoritter
                Object? testmap = doc.data();
                LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));

                if (userMap['userID'] == uid) {
                  favoriteUser = userMap['favorites'];
                  currentUserFavorties = userMap["favorites"];
                }
              });

              snapshot.data!.docs.forEach((doc) {
                //for-loop der gemmer alle favoriserede apartments under en liste
                Object? testmap = doc.data();
                LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));
                if (favoriteUser.contains(userMap['userID'])) {
                  apartmentsLists.add(Apartment(
                      description: userMap['description'],
                      city: userMap['myCountry'] ?? "not available",
                      address: userMap['myAdress'] ?? "not available",
                      apartmentImage:
                          userMap['apartmentImage'] ?? "no available",
                      profileImage: userMap['profileImage'] ?? "not available",
                      savedFavorite:
                          (currentUserFavorties.contains(userMap["userID"]))
                              ? true
                              : false,
                      goingTo: ["test1", "test2"],
                      userID: userMap['userID'] ?? "not available",
                      semester: userMap['semester'] ?? "not available",
                      appartmentType:
                          userMap['apartmentType'] ?? "not available",
                      year: userMap['year'] ?? "not available",
                      currentUser: 'not available'));
                }
              });

              if (apartmentsLists.isEmpty) {
                return Center(
                  child: Text("No Favorites, find some at search screen."),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView.builder(
                      //laver apartments for alle apartments som er favorites
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: apartmentsLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return apartmentsLists[index].getCard();
                      },
                    )),
                  ],
                ),
              );
            }));
  }
}
