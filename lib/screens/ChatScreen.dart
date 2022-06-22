import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/FirebaseMethods.dart';
import "../widgets/chatwidget.dart";
import "../widgets/chatsLine.dart";

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat-screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> currentUserChats = [];
  late String currentUserName;

  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseMethods.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitSquareCircle(
                    color: Colors.pink,
                    size: 80,
                  ),
            );
          }

          // get the chatArray.
          Object? userDocument = snapshot.data!.data();
          userDocument = userDocument as Map<String, dynamic>;
          List<dynamic> currentUserChats = userDocument["chats"];
          currentUserName = userDocument["firstName"];

          return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("chats").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> chatsSnapshot) {
                if (!snapshot.hasData || !chatsSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("No chats"),
                  );
                }

                List<ChatLineModel> chatUsers = [];

                for (var doc in chatsSnapshot.data!.docs) {
                  Object? testmap = doc.data();
                  LinkedHashMap<dynamic, dynamic> testlinked =
                      testmap as LinkedHashMap<dynamic, dynamic>;
                  Map<String, dynamic> chatMap =
                      testlinked.map((a, b) => MapEntry(a, b));
                  // print("before if statement");
                  if (currentUserChats.contains(chatMap["chatId"])) {
                    if (chatMap["users"][0]["name"] == currentUserName) {
                      // print("andreas found");
                      chatUsers.add(ChatLineModel(
                        shaKey: chatMap["chatId"],
                        name: chatMap["users"][1]["name"] ?? "name not found",
                        messageText:
                            chatMap["users"][1]["messageText"] ?? "no message",
                        imageUrl: chatMap["users"][1]["imageUrl"] ?? "no image",
                        time: chatMap["users"][1]["time"] ?? "unknown",
                        currentUserName: currentUserName,
                      ));
                    } else {
                      chatUsers.add(ChatLineModel(
                        shaKey: chatMap["chatId"],
                        name: chatMap["users"][0]["name"] ?? "name not found",
                        messageText:
                            chatMap["users"][0]["messageText"] ?? "no message",
                        imageUrl: chatMap["users"][0]["imageUrl"] ?? "no image",
                        time: chatMap["users"][0]["time"] ?? "unknown",
                        currentUserName: currentUserName,
                      ));
                    }

                    // print("inside if statement $chatUsers");
                  }
                }
                if (chatUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      "No chats found... \nGo find some new friends at the Search Screen :)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: chatUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return chatUsers[index].getChatsLine();
                      },
                    ))
                  ],
                );
              });
        });
  }
}
