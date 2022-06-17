import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './ProfileApartment.dart';
import './Profile_personal_info.dart';

Future<Map<String, dynamic>?> getdata(String documentId) async {
  var users = FirebaseFirestore.instance.collection('users');
  var userId = await users.doc(documentId).get();
  return userId.data();
}

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
  var firstName = 'Loading...';
  var lastName = 'Loading...';
  var profileImage =
      'https://firebasestorage.googleapis.com/v0/b/studentswap-fbf76.appspot.com/o/blankImage.jpeg?alt=media&token=0d0a00ce-a80e-41e7-930e-cb23fc9ccf68';
  __ProfileScreenState() {
    getdata(userId).then((userData) => setState(() {
          firstName = userData?['firstName'];
          lastName = userData?['lastName'];
          profileImage = userData?['profileImage'];
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                CircleAvatar(
                    radius: 65, backgroundImage: NetworkImage(profileImage)),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
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
                padding: EdgeInsets.all(15),
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
            padding: const EdgeInsets.all(15),
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
          padding: const EdgeInsets.all(15),
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
