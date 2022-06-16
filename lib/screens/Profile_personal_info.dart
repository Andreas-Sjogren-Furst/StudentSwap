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
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController profilePicture = TextEditingController();
  var userAuth = FirebaseAuth.instance.currentUser!.uid;

  _ProfileInfoState() {
    getdata(userAuth).then((userData) => setState(() {
          firstName.text = userData?['First name'];
          lastName.text = userData?['Last name'];
          city.text = userData?['City'];
          address.text = userData?['Address'];
          email.text = userData?['E-mail'];
          gender.text = userData?['Gender'];
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal information'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/sample/profile2.jpg'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                'Edit personal info',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextFormField(
                  controller: city,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                  ),
                  onFieldSubmitted: (String inputField) {
                    writedata(userAuth, 'myCountry', inputField);
                  },
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
    );
  }
}
