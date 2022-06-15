import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_page/widgets/Apartment.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = "/Favorites-Screen";

  final uid = FirebaseAuth.instance.currentUser!.uid;

  final FirestoreUserReference = FirebaseFirestore.instance.collection("users");

  getData() async {
    var userDocument = await FirestoreUserReference.doc(uid).get();
    return await userDocument['favorites'];
  }

  createApartment(String uid) async {
    var userDocument = await FirestoreUserReference.doc(uid).get();
    return await userDocument;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineSmall!,
      textAlign: TextAlign.center,
      child: FutureBuilder<dynamic>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  // var userDocument = createApartment(snapshot.data[index]);
                  // Apartment apartment = Apartment(city: userDocument['city'], address: userDocument['address'], apartmentImage: userDocument['apartmentImage'], profileImage: userDocument['profileImage']);
                  // return apartment.getCard();
                  return Text(snapshot.data[index]);
                },
              ))
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
