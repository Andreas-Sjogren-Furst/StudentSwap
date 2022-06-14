import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Apartment {

  late String city;
  late String address;
  late String apartmentImage;
  late String profileImage;

  bool saved = false;

  Apartment({required this.city, required this.address, required this.apartmentImage, required this.profileImage});

  ApartmentCard getCard() {
    return ApartmentCard(apartmentImage: apartmentImage, city: city, address: address, profileImage: profileImage);
  }

}

Future<void> updateUser(ApartmentCard apartmentCard) {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  return users
    .doc(uid)
    .update({
      'favorites': FieldValue.arrayUnion([apartmentCard.address])
      });
}

class ApartmentCard extends StatefulWidget {
  const ApartmentCard({
    Key? key,
    required this.apartmentImage,
    required this.city,
    required this.address,
    required this.profileImage,
  }) : super(key: key);

  final String apartmentImage;
  final String city;
  final String address;
  final String profileImage;


  @override
  State<ApartmentCard> createState() => _ApartmentCardState();
}

class _ApartmentCardState extends State<ApartmentCard> {
  @override

  bool saved = false;

  Widget build(BuildContext context) {
    return Card(
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0)),
                child: Image(image: AssetImage("assets/sample/${widget.apartmentImage}.jpg"), fit: BoxFit.fitHeight),
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
                            updateUser(widget);
                            setState(() {
                              saved = !saved; // TODO: Save favorited items
                            });
                          }, // TODO: Add favorite function
                          label: const Text(
                            "Save",
                            style: TextStyle(fontSize: 14, fontFamily: "Poppins", fontWeight: FontWeight.w600),
                          ),
                          icon: Icon(
                            saved ? Icons.favorite_sharp : Icons.favorite_border_sharp,
                            size: 24.0,
                          ),
                          style: TextButton.styleFrom(
                            primary: saved ? Colors.red : Colors.grey,
                            padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                          )
                        ),
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/sample/${widget.profileImage}.jpg"), // TODO: Get profile picture from Firebase
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
    );
  }
}