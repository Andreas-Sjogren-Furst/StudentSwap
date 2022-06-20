import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<List<dynamic>> findRelevantMacthes() async {
  var usersData = [];
  var db = FirebaseFirestore.instance.collection('users');
  var userId = await db.get();
  for (var users in userId.docs) {
    usersData.add(users.data());
  }
  return usersData;
}

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool _isLoading = true;
  var userAuth = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> usersData = [];

  @override
  void initState() {
    super.initState();
    print(usersData);
  }

  dataLoadFunction() async {
    usersData = await findRelevantMacthes();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    print(usersData);
                  });
                },
                child: Text('${usersData.length}'))
          ],
        ),
      ),
    );
  }
}
