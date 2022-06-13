import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "../services/firebase_methods.dart";

class ProfileScreen extends StatefulWidget {
  static const routeName = "/Profile-Screen";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => __ProfileScreenState();
}

class __ProfileScreenState extends State<ProfileScreen> {
  static const routeName = "/profile-Screen";
  final user = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  // final docRef = FirebaseFirestore.instance.collection("users").doc(userId);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Signed in as: ${user?.email}'),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          color: Colors.deepOrange,
          child: Text('Sign out'),
        ),
        MaterialButton(
          onPressed: () {
            Future<Map<String, dynamic>?> testmap =
                FirebaseMethods.getUserData();
            testmap.then((value) {
              print(value);
            });
          },
          child: Text("Get all users"),
        ),
        MaterialButton(
          onPressed: () async {
            var test = await FirebaseMethods.getSpecificUserData("username");
            print(test);
          },
          child: (Text("Get current user")),
        ),

        // StreamBuilder<QuerySnapshot>(
        //   stream: _usersStream,
        //   builder:
        //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (snapshot.hasError) {
        //       return Text('Something went wrong');
        //     }

        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Text("Loading");
        //     }

        //     return ListView(
        //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //         Map<String, dynamic> data =
        //             document.data()! as Map<String, dynamic>;
        //         return ListTile(
        //           title: Text(data['profile_picture_url']),
        //           subtitle: Text(data['username']),
        //         );
        //       }).toList(),
        // );
        // },
        // )
      ],
    ));
  }
}
