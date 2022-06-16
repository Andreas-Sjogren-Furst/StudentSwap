import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './ProfileApartment.dart';
import './Profile_personal_info.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              children: const [
                CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/sample/profile2.jpg')),
                Text(
                  'Hailey Jefferson',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey),
            FlatButton(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileApartment()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Apartment images',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                )),
          ],
        ),
        const Divider(
          color: Colors.grey,
        ),
        FlatButton(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileInfo()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Personal information',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            )),
        const Divider(color: Colors.grey),
        FlatButton(
          padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Log out',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(
                Icons.logout,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey)
      ],
    );
  }
}
