// import 'dart:collection';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../services/FirebaseMethods.dart';
// import "../widgets/chatwidget.dart";
// import "../widgets/chatsLine.dart";

// class ChatScreen extends StatefulWidget {
//   static const routeName = "/chat-screen";

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final user = FirebaseAuth.instance.currentUser;
//   final userId = FirebaseAuth.instance.currentUser!.uid;
//   List currentUserChats = [];

//   @override
//   void initState() {
//     // TODO: implement initState

//     //     await FirebaseFirestore.instance
//     //         .collection("users")
//     //         .doc(FirebaseMethods.userId)
//     //         .snapshots();
//     // Object? userDocument = snapshot
//     // userDocument = userDocument as Map<String, dynamic>;
//     // List<dynamic> CurrentUserChats = userDocument["chats"];

//     super.initState();
//   }

//   // Null check, null safety, aner ikke om det er korrekt. TODO: null check safety.
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(FirebaseMethods.userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.lightBlueAccent,
//               ),
//             );
//           }
//           print("userchats $currentUserChats");
//           List<ChatLineModel> chatUsers = [
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//             ChatLineModel(
//                 name: "Jane Russel",
//                 messageText: "Awesome Setup",
//                 imageUrl: "assets/profile1.jpg",
//                 time: "Now"),
//           ];

    
//           Object? userDocument = snapshot.data!.data();
//           userDocument = userDocument as Map<String, dynamic>;
//           List<dynamic> CurrentUserChats = userDocument["chats"];

//           print("chats  $CurrentUserChats");

//           CurrentUserChats.forEach((chat) async {
//             print("chat $chat");

//             late String imageUrl;
//             late String name;
//             late String messageText;
//             late String time;

//             await FirebaseFirestore.instance
//                 .collection("chats")
//                 .doc(chat)
//                 .get()
//                 .then((value) {
//               imageUrl = value["imageUrl"];
//               name = value["name"];
//               messageText = value["message"];
//               time = value["time"];

//               chatUsers.add(ChatLineModel(
//                 name: name,
//                 messageText: messageText,
//                 imageUrl: imageUrl,
//                 time: time,
//               ));
//             });

//             // chatDocument = chatDocument as DocumentSnapshot;

//             // print("chatDocument $chatDocument");

//             // Stream<DocumentSnapshot<Map<String, dynamic>>> chatSnapshot =
//             //     FirebaseFirestore.instance
//             //         .collection("chats")
//             //         .doc(chat)
//             //         .snapshots();

//             // print("chatSnapshot $document");

//             // await chatSnapshot.then((event) => setState(() =>
//             //   chatUsers.add(
//             //       ChatLineModel(
//             //           name: event.data()!["name"],
//             //           messageText: event.data()!["message"],
//             //           imageUrl: event.data()!["imageUrl"],
//             //           time: event.data()!["time"]))));
//           });

//           // await for (final value in chatSnapshot) {
//           //   print("before if statement");
//           //   if (value.exists) {
//           //     print("vlaue exsists");
//           //     // Evt. setState
//           //     chatUsers.add(ChatLineModel(
//           //         name: value.data()!["name"],
//           //         messageText: value.data()!["message"],
//           //         imageUrl: value.data()!["imageUrl"],
//           //         time: value.data()!["time"]));
//           //   }
//           // }
//           // });

//           // chatSnapshot.then((chatSnapshot) {
//           //   chatUsers.add(ChatLineModel(
//           //     name: chatSnapshot.data()["name"],
//           //     messageText: chatSnapshot.data()["messageText"],
//           //     imageUrl: chatSnapshot.data()["imageUrl"],
//           //     time: chatSnapshot.data()["time"],
//           //   ));
//           // });
//           // chatUsers.add(ChatLineModel(name: name, messageText: messageText, imageUrl: imageUrl, time: time))

//           List<int> bytes = utf8.encode('message');
//           String hash = sha256.convert(bytes).toString();
//           print(hash);

//           return Column(
//             children: [
//               Expanded(
//                   child: ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 physics: const ClampingScrollPhysics(),
//                 itemCount: chatUsers.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return chatUsers[index].getChatsLine();
//                 },
//               ))
//             ],
//           );
//         });

//     // StreamBuilder(
//     //     stream: FirebaseFirestore.instance
//     //         .collection("chats/PPlVfldzdA0srBOjlgY2/messages")
//     //         .snapshots(),
//     //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//     //       if (streamSnapshot.connectionState == ConnectionState.waiting) {
//     //         return Center(
//     //           child: CircularProgressIndicator(),
//     //         );
//     //       }
//     //       if (streamSnapshot.hasData &&
//     //           streamSnapshot.data!.docs.length > 0) {
//     //         return ListView.builder(
//     //           itemCount: streamSnapshot.data!.docs.length,
//     //           itemBuilder: (context, index) {
//     //             return ListTile(
//     //               title: Text(streamSnapshot.data!.docs[index]["text"]),
//     //             );
//     //           },
//     //         );
//     //       } else {
//     //         return Center(child: Text("Currently no messages."));
//     //       }
//     //     }),

//     // MaterialButton(
//     //   onPressed: () {
//     //     FirebaseAuth.instance.signOut();
//     //   },
//     //   color: Colors.deepOrange,
//     //   child: Text('Sign out'),
//     // ),
//     // MaterialButton(
//     //   onPressed: () async {
//     //     Future<Map<String, dynamic>> testmap =
//     //         await FirebaseMethods.getUserData();
//     //     print("button out: " + testmap.toString());
//     //   },
//     //   child: Text("Get current user"),
//     // ),
//     //     MaterialButton(
//     //       onPressed: () async {
//     //         var userDocument = await FirebaseMethods.getUserDocument(userId);
//     //         print(userDocument["username"]);
//     //       },
//     //       child: (Text("Get current user ")),
//     //     ),
//     //   ],
//     // ),

//     // if (!streamSnapshot.hasData) {
//     //   return Center(
//     //     child: Text("Firestore Snapshot has not data"),
//     //   );
//     // }

//     // if (streamSnapshot.hasError) {
//     //   return Center(
//     //     child: Text("Firestore Snapshot has an error"),
//     //   );
//     // }

//     // if (streamSnapshot.data == null ||
//     //     streamSnapshot.data?.docs == null) {
//     //   return Center(
//     //     child: Text("Firestore snapshot is null"),
//     //   );
//     // } else {
//     //   return ListView.builder(
//     //     itemCount: streamSnapshot.data!.docs.length,
//     //     itemBuilder: (context, index) {
//     //       return ListTile(
//     //         title: Text(streamSnapshot.data?.docs[index]["text"]),
//     //       );
//     //     },
//     //   );
//     // }

//     // if (streamSnapshot.data == null ||
//     //     streamSnapshot.data?.docs == null) {
//     //   return const Text("Snapshot.data is null..");
//     // }

//     // print("streamSnapshot.data.docs: ${streamSnapshot.data?.docs}");
//     // final documents = streamSnapshot.data?.docs;
//     // if (documents == null || documents.isEmpty) {
//     //   print("document is empty");
//     //   // return Center(
//     //   //   child: Text("No messages yet"),
//     //   // );
//     // }
//     // //else {
//     // //   return ListView.builder(
//     // //       itemCount: documents.length,
//     // //       itemBuilder: ((context, index) => Container(
//     // //           padding: EdgeInsets.all(8),
//     // //           child: Text(documents[index]["text"]))));
//     // // }
//     // return Text("lolcat returned");

//     // floatingActionButton: FloatingActionButton(
//     //     child: Icon(Icons.add),
//     //     onPressed: () => (FirebaseFirestore.instance
//     //             .collection("chats/PPlVfldzdA0srBOjlgY2/messages")
//     //             .add({
//     //           "text": "Hello World",
//     //         }))),
//   }
// }
