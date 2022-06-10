import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/chat-screen";

  @override

  // Null check, null safety, aner ikke om det er korrekt. TODO: null check safety.
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats/PPlVfldzdA0srBOjlgY2/messages")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (streamSnapshot.hasData &&
                streamSnapshot.data!.docs.length > 0) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(streamSnapshot.data!.docs[index]["text"]),
                  );
                },
              );
            } else {
              return Center(child: Text("Currently no messages."));
            }
          }),

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
        onPressed: () => (print("lolcat")),
      ),
    );
  }
}
