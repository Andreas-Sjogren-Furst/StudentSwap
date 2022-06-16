import 'dart:collection';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/widgets/Apartment.dart';
import 'package:firebase_core/firebase_core.dart';



class FavoritesScreen extends StatelessWidget {
  static const routeName = "/Favorites-Screen";

  final uid = FirebaseAuth.instance.currentUser!.uid;

  final FirestoreUserReference = FirebaseFirestore.instance.collection("users");


  getData() async{
    var userDocument = await FirestoreUserReference.doc(uid).get(); 
    return await userDocument['favorites'];
  }

  createApartment(String uid) async {
    var userDocument = await FirestoreUserReference.doc(uid).get();
    return await userDocument; 
  }

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
          
              List<Apartment> apartmentsLists = [];
              List<Apartment> apartments = [];
              List<dynamic> favoriteUser = []; 

              snapshot.data!.docs.forEach((doc) {
                 Object? testmap = doc.data();
                  LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                  Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));
                  
                
                if(userMap['userID'] == uid) {
                  favoriteUser = userMap['favorites'];
                }
              }
              );

              
              

              snapshot.data!.docs.forEach((doc) {
                Object? testmap = doc.data();
                LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));
                    if(favoriteUser.contains(userMap['userID'])) {
                    apartmentsLists.add(Apartment(
                    city: userMap['city'] ?? "not available",
                    address: userMap['address'] ?? "not available",
                    apartmentImage: userMap['apartmentImage'] ?? "no available",
                    profileImage: userMap['profileImage'] ?? "not available",
                    savedFavorite: userMap['savedFavorite'] ?? false,
                    goingTo: ["test1", "test2"],
                    userID: userMap['userID'] ?? "not available"));
                    }
                }
              );
          

              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView.builder(
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