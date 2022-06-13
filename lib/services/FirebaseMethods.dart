import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final userId = FirebaseAuth.instance.currentUser!.uid;
  static final FirestoreUserReference =
      FirebaseFirestore.instance.collection("users");

  // get user's data from firstore collection.
  static Future<dynamic> getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(
            'Document data: ${documentSnapshot.data() as Map<String, dynamic>}');
        return documentSnapshot.data();
        ;

        // print("Username: ${documentSnapshot.get("username")}");
      } else {
        print('Document does not exist on the database, null returned');
      }
      return null;
    });
  }

  // var a = await getData();
  //   print(a); //my expected result

  static Future getUserdDocument(String userId) async {
    var userDocument = await FirestoreUserReference.doc(userId).get();

    return userDocument;
  }

// get specific user data from firestore collection.
  static dynamic getSpecificUserData(String key) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.get(key)}');
        return documentSnapshot.get(key);
      } else {
        print('Document does not exist on the database, null returned');
        return "no data";
      }
    });
  }
}
