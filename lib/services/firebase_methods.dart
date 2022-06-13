import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final userId = FirebaseAuth.instance.currentUser!.uid;

  // get user's data from firstore collection.
  static Future<Map<String, dynamic>?> getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(
            'Document data: ${documentSnapshot.data() as Map<String, dynamic>}');
        return documentSnapshot.data() as Map<String, dynamic>;

        // print("Username: ${documentSnapshot.get("username")}");
      } else {
        print('Document does not exist on the database, null returned');
        return null;
      }
    });
  }

// get specific user data from firestore collection.
  static dynamic getSpecificUserData(String key) async {
    await FirebaseFirestore.instance
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
