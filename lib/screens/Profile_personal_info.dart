import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> getdata(String documentId) async {
  var users = FirebaseFirestore.instance.collection('users');
  var userId = await users.doc(documentId).get();
  return userId.data();
}

void writedata(String documentId, String changeVar, String toVar) async {
  final users = FirebaseFirestore.instance.collection('users').doc(documentId);
  await users.update({changeVar: toVar});
}

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController profilePicture = TextEditingController();
  String profileImage =
      'https://firebasestorage.googleapis.com/v0/b/studentswap-fbf76.appspot.com/o/Blank_image.jpeg?alt=media&token=005320db-a0b7-48c8-b653-44285e7c079a';
  var userAuth = FirebaseAuth.instance.currentUser!.uid;

  _ProfileInfoState() {
    getdata(userAuth).then((userData) => setState(() {
          firstName.text = userData?['firstName'];
          lastName.text = userData?['lastName'];
          country.text = userData?['myCountry'];
          address.text = userData?['myAddress'];
          email.text = userData?['Email'];
          gender.text = userData?['gender'];
          profileImage = userData?['profileImage'];

        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24.0,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 24.0),
                      child: Text(
                        'Personal information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(profileImage),

                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Edit personal info',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: firstName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First name',
                        ),
                        onFieldSubmitted: (String inputField) {
                          writedata(userAuth, 'firstName', inputField);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: lastName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last name',
                        ),
                        onFieldSubmitted: (String inputField) {
                          writedata(userAuth, 'lastName', inputField);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: country,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Country',
                        ),
                        onFieldSubmitted: (String inputField) {
                          writedata(userAuth, 'myCountry', inputField);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: address,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Address',
                        ),
                        onFieldSubmitted: (String inputField) {
                          writedata(userAuth, 'myAddress', inputField);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        onFieldSubmitted: (String inputField) {
                          writedata(userAuth, 'Email', inputField);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: gender,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Gender',
                        ),
                        onFieldSubmitted: (String inputField) {
                          writedata(userAuth, 'gender', inputField);
                        },
                      )),
                ],
              ),
          ),
            ),
        ]),
      ),
    );
  }
}
