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
  var firstName = 'Loading...';
  var lastName = '';
  var profileImage =
      'https://firebasestorage.googleapis.com/v0/b/studentswap-fbf76.appspot.com/o/Blank_image.jpeg?alt=media&token=005320db-a0b7-48c8-b653-44285e7c079a';

  @override
  void initState() {
    getdata(userId).then((userData) => setState(() {
          firstName = userData?['firstName'];
          lastName = userData?['lastName'];
          profileImage = userData?['profileImage'];
        }));
    super.initState();
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
            const Divider(color: Colors.grey),
            FlatButton(
                padding: const EdgeInsets.all(15),
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
                      'Apartment Photos',
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
                MaterialPageRoute(builder: (context) => ProfileInfo()),
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
