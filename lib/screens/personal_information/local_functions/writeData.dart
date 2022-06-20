import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void writeData(String changeVar, String toVar) async {
  var userAuth = FirebaseAuth.instance.currentUser!.uid;
  final users = FirebaseFirestore.instance.collection('users').doc(userAuth);
  await users.update({changeVar: toVar});
}
