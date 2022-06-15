import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_page/screens/ApartmentScreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apartment {
  late String city;
  late String address;
  late String apartmentImage;
  late String profileImage;
  late String semester;
  late bool savedFavorite;
  late String userID;
  late List<dynamic> goingTo;
  late String appartmentType;

  bool saved = false;

  Apartment({
    required this.city,
    required this.address,
    required this.apartmentImage,
    required this.profileImage,
    required this.savedFavorite,
    required this.goingTo,
    required this.userID,
    required this.semester,
    required this.appartmentType,
  });

  ApartmentCard getCard() {
    return ApartmentCard(
      apartmentImage: apartmentImage,
      city: city,
      address: address,
      profileImage: profileImage,
      savedFavorite: savedFavorite,
      userID: userID,
      goingTo: goingTo,
      semester: semester,
      appartmentType: appartmentType,
    );
  }
}

// Future<bool> checkFavorite(Apartment apartmentCard) async {
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   final FirestoreUserReference = FirebaseFirestore.instance.collection("users");
//   var userDocument = await FirestoreUserReference.doc(uid).get();

//   if(userDocument['favorites'].any((e) => e.contains(apartmentCard.userID))){
//     return true;
//   } else {
//     return false;
//   }
// }

//   final FirestoreUserReference = FirebaseFirestore.instance.collection("users");
//   var userDocument = await FirestoreUserReference.doc(uid).get();

//   if(userDocument['favorites'].any((e) => e.contains(apartmentCard.userID))){
//     return true;
//   } else {
//     return false;
//   }
// }

Future<void> updateUser(ApartmentCard apartmentCard, bool saved) {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // final FirestoreUserReference = FirebaseFirestore.instance.collection("users");
  // var userDocument = await FirestoreUserReference.doc(uid).get();

  // var userDocument = await FirestoreUserReference.doc(uid).get();

  // if(userDocument['favorites'].any((e) => e.contains(apartmentCard.userID))){
  //   return users
  //   .doc(uid)
  //   .update({
  //     'favorites': FieldValue.arrayRemove([apartmentCard.address])
  //     });

  // } else {
  //   return users
  //   .doc(uid)
  //   .update({
  //     'favorites': FieldValue.arrayUnion([apartmentCard.address])
  //     });
  // }

  if (saved) {
    return users.doc(uid).update({
      'favorites': FieldValue.arrayUnion([apartmentCard.address])
    });
  } else {
    return users.doc(uid).update({
      'favorites': FieldValue.arrayRemove([apartmentCard.address])
    });
  }
}

class ApartmentCard extends StatefulWidget {
  const ApartmentCard(
      {Key? key,
      required this.apartmentImage,
      required this.city,
      required this.address,
      required this.profileImage,
      required this.userID,
      required this.savedFavorite,
      required this.goingTo,
      required this.semester,
      required this.appartmentType})
      : super(key: key);

  final String apartmentImage;
  final String city;
  final String address;
  final String profileImage;
  final String semester;
  final String userID;
  final bool savedFavorite;
  final List<dynamic> goingTo;
  final String appartmentType;

  @override
  State<ApartmentCard> createState() => _ApartmentCardState();
}

class _ApartmentCardState extends State<ApartmentCard> {
  @override
  bool saved = false;

  Widget build(BuildContext context) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pushNamed(context, ApartmentScreen.routeName,
            arguments: <String, dynamic>{
              'apartmentImage': widget.apartmentImage,
              'city': widget.city,
              'address': widget.address,
              'profileImage': widget.profileImage,
              'userID': widget.userID,
              'savedFavorite': widget.savedFavorite,
              'goingTo': widget.goingTo,
              "semester": widget.semester,
            });
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0)),
                  child: Image(
                      image: NetworkImage("${widget.apartmentImage}"),
                      fit: BoxFit.fitHeight),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.city,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.address,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins",
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  saved = !saved; // TODO: Save favorited items
                                });
                              }, // TODO: Add favorite function
                              label: const Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600),
                              ),
                              icon: Icon(
                                saved
                                    ? Icons.favorite_sharp
                                    : Icons.favorite_border_sharp,
                                size: 24.0,
                              ),
                              style: TextButton.styleFrom(
                                primary: saved ? Colors.red : Colors.grey,
                                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                              )),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "${widget.profileImage}"), // TODO: Get profile picture from Firebase
                            radius: 17.0,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
