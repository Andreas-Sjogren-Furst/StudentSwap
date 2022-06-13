import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './profile_apartment.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = "/profile-Screen";
  @override
  State<ProfileScreen> createState() => __ProfileScreenState();
}

class __ProfileScreenState extends State<ProfileScreen> {
  //static const routeName = "/profile-Screen";
  final user = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/sample/profile1.jpg')),
                Text('Jefferson'),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text('Signed in as: ${user?.email}'),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.deepOrange,
            child: Text('Sign out'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const profile_apartment()),
              );
            },
            child: Text('hello'),
          )
        ],
      ),
    );
  }
}
