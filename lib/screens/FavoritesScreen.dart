import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_page/models/Apartment.dart';
import 'package:firebase_core/firebase_core.dart';



class FavoritesScreen extends StatelessWidget {
  static const routeName = "/Favorites-Screen";

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    dynamic usersname; 
    
    getData() async{
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(uid);
      usersname = userDocument.get();

    }
    getData(); 

    print(usersname);
    return Container();


    // return Container(
    //   child: Column(
    //     children: [
    //       Expanded(
    //             child: ListView.builder(
    //               scrollDirection: Axis.vertical,
    //               shrinkWrap: true,
    //               physics: const ClampingScrollPhysics(),
    //               itemCount: apartmentList.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return apartmentList[index].getCard();
    //               },
    //             )
    //         ),
    //     ],
    //   )
    // );
  }
}
