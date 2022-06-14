// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_page/widgets/Apartment.dart';
import 'dart:convert';

class ApartmentScreen extends StatefulWidget {
  static const routeName = "/apartment-screen";

  const ApartmentScreen({Key? key}) : super(key: key);

  @override
  State<ApartmentScreen> createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {

  String oneOrMore(List<String> destinationer) {
    return destinationer.length > 1 ? 'Destinations' : 'Destination';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String apartmentImage = args['apartmentImage'] ?? 'not available';
    String city = args['city'] ?? 'not available';
    String address = args['address'] ?? 'not available';
    String profileImage = args['profileImage'] ?? 'not available';
    String userID = args['userID'] ?? 'not available';
    bool savedFavorite = args['savedFavorite'] != null;
    List<String> goingTo = args['goingTo'];

    //String listeAfDestinationer = goingTo.map((g) => g.toString()).toString();

  String listeAfDestinationer(List<String> value) {
    String output='';
    value.forEach((x)=>x.toString());
    output = value.join(', ');
    return output;
}

    // apartmentImage's kan hentes fra firebase?
    // hvis ja kan man lave et array med alle apartment billederne.

    var lejlighedsPics = [
      'assets/sample/apartment1.jpg',
      'assets/sample/apartment2.jpg',
      'assets/sample/apartment1.jpg',
      'assets/sample/apartment2.jpg'
    ];

    // ovenstående liste skal på en eller anden måde initialiseres fra firebase.

    // vi skal også bruge info om hvor vedkommende skal hen ogh kommer fra - VIGTIGT

    return Scaffold(
      appBar: AppBar(
        title: Text('$address, $city'),
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    backgroundImage:
                        AssetImage('assets/sample/$profileImage.jpg'),
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
            "$userID", // tilføj et brugernavn/rigtigt navn/userID?
            style: TextStyle(
                color: Colors.black, fontSize: 30.0, fontFamily: "Poppins"),
          ),
          Divider(
            indent: 30,
            endIndent: 30,
            color: Colors.grey,
            thickness: 2,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "From",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(city)
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          oneOrMore(goingTo),
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(listeAfDestinationer(goingTo))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: lejlighedsPics.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage(lejlighedsPics[index]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          )),
        ],
      )),
    );
  }
}
