// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_page/models/Apartment.dart';

class ApartmentScreen extends StatefulWidget {
  static const routeName = "/apartment-screen";

  const ApartmentScreen({Key? key}) : super(key: key);

  @override
  State<ApartmentScreen> createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    String apartmentImage = args['apartmentImage'] ?? 'not available';
    String city = args['city'] ?? 'not available';
    String address = args['address'] ?? 'not available';
    String profileImage = args['profileImage'] ?? 'not available';

    // apartmentImage's kan hentes fra firebase?
    // hvis ja kan man lave et array med alle apartment billederne.

    return Scaffold(
      appBar: AppBar(
        title: Text('$address, $city'),
      ),
      body: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
        shape: const CircleBorder(),
        color: Colors.blue,
        padding: const EdgeInsets.all(20),
        onPressed: () {},
        child: const Icon(
          Icons.email,
          size: 50,
          color: Colors.white,
        ),
),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/sample/$profileImage.jpg'),
                    radius: 100,
                  ),
                ),
              ),
               MaterialButton(
        shape: const CircleBorder(),
        color: Colors.blue,
        padding: const EdgeInsets.all(20),
        onPressed: () {},
        child: const Icon(
          Icons.favorite,
          size: 50,
          color: Colors.white,
        ),
),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          // ignore: prefer_const_constructors
          Text(
            "?userName?", // tilføj et brugernavn/rigtigt navn/userID?
            style: TextStyle(
                color: Colors.grey, fontSize: 30.0, fontFamily: "Poppins"),
          ),
          Divider(
            indent: 30,
            endIndent: 30,
            color: Colors.grey,
            thickness: 2,
          ),

          // ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   physics: const ClampingScrollPhysics(),

          //   itemBuilder: (context, index) {
          //     return Text("røvhulshul");
          //   },
            
            
          // )
          
          ],
        )
      ),
    );
  }
}
