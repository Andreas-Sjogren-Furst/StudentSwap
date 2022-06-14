import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class profile_info extends StatefulWidget {
  const profile_info({Key? key}) : super(key: key);

  @override
  State<profile_info> createState() => _profile_infoState();
}

class _profile_infoState extends State<profile_info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_arrow_left_outlined)),
              Center(
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/sample/profile2.jpg'),
                ),
              ),
            ],
          ),
          //SizedBox(height: 30),
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

          //SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  labelText: 'First name',
                ),
                initialValue: 'Hailey',
                onSaved: (String? value) {},
              )),
          //SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  labelText: 'Last name',
                ),
                initialValue: 'Jefferson',
                onSaved: (String? value) {},
              )),
          //SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  labelText: 'City',
                ),
                initialValue: 'Amsterdam',
                onSaved: (String? value) {},
              )),
          //SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  labelText: 'Address',
                ),
                initialValue: 'Osdorpplein 372A, 1068 EV',
                onSaved: (String? value) {},
              )),
          //SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  labelText: 'E-mail',
                ),
                initialValue: 'haley@jessica.com',
                onSaved: (String? value) {},
              )),
          //SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
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
