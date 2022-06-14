import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../services/FirebaseMethods.dart';

class profile_info extends StatefulWidget {
  const profile_info({Key? key}) : super(key: key);

  @override
  State<profile_info> createState() => _profile_infoState();
}

class _profile_infoState extends State<profile_info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal information'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/sample/profile2.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First name',
                ),
                initialValue: 'Hailey',
                onSaved: (String? value) {},
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last name',
                ),
                initialValue: 'Jefferson',
                onSaved: (String? value) {},
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
                initialValue: 'Amsterdam',
                onSaved: (String? value) {},
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
                initialValue: 'Osdorpplein 372A, 1068 EV',
                onSaved: (String? value) {},
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
                initialValue: 'haley@jessica.com',
                onSaved: (String? value) {},
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gender',
                ),
                initialValue: 'Female',
                onSaved: (String? value) {},
              )),
        ],
      ),
    );
  }
}
