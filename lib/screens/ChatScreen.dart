import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/FirebaseMethods.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/chat-screen";
  final user = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override

  // Null check, null safety, aner ikke om det er korrekt. TODO: null check safety.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection("chats/PPlVfldzdA0srBOjlgY2/messages")
          //         .snapshots(),
          //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          //       if (streamSnapshot.connectionState == ConnectionState.waiting) {
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //       if (streamSnapshot.hasData &&
          //           streamSnapshot.data!.docs.length > 0) {
          //         return ListView.builder(
          //           itemCount: streamSnapshot.data!.docs.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(streamSnapshot.data!.docs[index]["text"]),
          //             );
          //           },
          //         );
          //       } else {
          //         return Center(child: Text("Currently no messages."));
          //       }
          //     }),
          Text('Signed in as: ${user?.email}'),
          // MaterialButton(
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //   },
          //   color: Colors.deepOrange,
          //   child: Text('Sign out'),
          // ),
          // MaterialButton(
          //   onPressed: () async {
          //     Future<Map<String, dynamic>> testmap =
          //         await FirebaseMethods.getUserData();
          //     print("button out: " + testmap.toString());
          //   },
          //   child: Text("Get current user"),
          // ),
          MaterialButton(
            onPressed: () async {
              var userDocument = await FirebaseMethods.getUserDocument(userId);
              print(userDocument["username"]);
            },
            child: (Text("Get current user ")),
          ),
        ],
      ),

      // if (!streamSnapshot.hasData) {
      //   return Center(
      //     child: Text("Firestore Snapshot has not data"),
      //   );
      // }

      // if (streamSnapshot.hasError) {
      //   return Center(
      //     child: Text("Firestore Snapshot has an error"),
      //   );
      // }

      // if (streamSnapshot.data == null ||
      //     streamSnapshot.data?.docs == null) {
      //   return Center(
      //     child: Text("Firestore snapshot is null"),
      //   );
      // } else {
      //   return ListView.builder(
      //     itemCount: streamSnapshot.data!.docs.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(streamSnapshot.data?.docs[index]["text"]),
      //       );
      //     },
      //   );
      // }

      // if (streamSnapshot.data == null ||
      //     streamSnapshot.data?.docs == null) {
      //   return const Text("Snapshot.data is null..");
      // }

      // print("streamSnapshot.data.docs: ${streamSnapshot.data?.docs}");
      // final documents = streamSnapshot.data?.docs;
      // if (documents == null || documents.isEmpty) {
      //   print("document is empty");
      //   // return Center(
      //   //   child: Text("No messages yet"),
      //   // );
      // }
      // //else {
      // //   return ListView.builder(
      // //       itemCount: documents.length,
      // //       itemBuilder: ((context, index) => Container(
      // //           padding: EdgeInsets.all(8),
      // //           child: Text(documents[index]["text"]))));
      // // }
      // return Text("lolcat returned");

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => (FirebaseFirestore.instance
                  .collection("chats/PPlVfldzdA0srBOjlgY2/messages")
                  .add({
                "text": "Hello World",
              }))),
    );
  }
}
