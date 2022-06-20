import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

class FirebaseMethods {
  static final userId = FirebaseAuth.instance.currentUser!.uid;
  static final FirestoreUserReference =
      FirebaseFirestore.instance.collection("users");

  // get user's data from firstore collection.
  // static Future<dynamic> getUserData() async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print(
  //           'Document data: ${documentSnapshot.data() as Map<String, dynamic>}');
  //       return documentSnapshot.data();
  //       ;

  //       // print("Username: ${documentSnapshot.get("username")}");
  //     } else {
  //       print('Document does not exist on the database, null returned');
  //     }
  //     return null;
  //   });
  // }

  // var a = await getData();
  //   print(a); //my expected result

  static Future getUserDocument(String userId) async {
    var userDocument = await FirestoreUserReference.doc(userId).get();

    return userDocument;
  }

  static String updateUserChats(String currentUserId, String counterUserId) {
    // TODO: Check om chat allerede eksisterer.
    String sha256String = generateSha256Hash(currentUserId, counterUserId);
    generateUserChat(sha256String, currentUserId, counterUserId);

    return sha256String;
  }

  // Makes the chats 100% anonymous, so we can't see which user each belongs to whom,
  // only by firstnames not userids. Also ensures we don't have duplicate chats.

  static String generateSha256Hash(String currentUserId, String counterUserId) {
    final String currentTime = DateTime.now().toString();
    print("current time $currentTime");

    List<int> bytes = utf8.encode('$currentUserId + $counterUserId');
    String hash = sha256.convert(bytes).toString();
    return hash;
  }

  static generateUserChat(String chatDoucmentName, String currentUserId,
      String counterUserId) async {
    var currentUserDocument = await getUserDocument(currentUserId);
    var counterUserDocument = await getUserDocument(counterUserId);

    List<dynamic> currentUserChats = await currentUserDocument.data()["chats"];
    List<dynamic> counterUserChats = await counterUserDocument.data()["chats"];

    print(
        "currentUserChats $currentUserChats + counterUserChats $counterUserChats");

    if (!currentUserChats.contains(chatDoucmentName) ||
        !counterUserChats.contains(chatDoucmentName)) {
      FirebaseFirestore.instance.collection("chats").doc(chatDoucmentName).set(
        {
          "chatId": chatDoucmentName,
          "Messages": [],
          "users": [
            {
              "name": currentUserDocument.data()["firstName"],
              "messageText": "lastest message",
              "imageUrl": currentUserDocument.data()["profileImage"],
              "time": "now",
            },
            {
              "name": counterUserDocument.data()["firstName"],
              "messageText": "lastest message",
              "imageUrl": counterUserDocument.data()["profileImage"],
              "time": "now",
            }
          ]
        },
      );

      // update currentUser:
      FirestoreUserReference.doc(currentUserId).update({
        "chats": FieldValue.arrayUnion([chatDoucmentName])
      });

      // update CounterUSer:
      FirestoreUserReference.doc(counterUserId).update({
        "chats": FieldValue.arrayUnion([chatDoucmentName])
      });
    } else {
      print("chat already exsits");
    }
  }

// get specific user data from firestore collection.
  // static dynamic getSpecificUserData(String key) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print('Document data: ${documentSnapshot.get(key)}');
  //       return documentSnapshot.get(key);
  //     } else {
  //       print('Document does not exist on the database, null returned');
  //       return "no data";
  //     }
  //   });
  // }
}
