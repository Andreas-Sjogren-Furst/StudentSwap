import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_page/widgets/UserImagePicker.dart';

class RegisterPage2 extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const RegisterPage2({
    Key? key,
    required this.showRegisterPage,
  }) : super(key: key);

  @override
  State<RegisterPage2> createState() => _RegisterPageState2();
}

class _RegisterPageState2 extends State<RegisterPage2> {
  final key_UserImagePicker = new GlobalKey<UserImagePickerState>();

  // text controllers
  final _semesterController = TextEditingController();
  final _myAddressController = TextEditingController();
  final _destinationController = TextEditingController();

  UserCredential? authResult; // To get the user UID . TODO: null check safety.
  File? get get_key_UserImagePicker_pickedImage =>
      key_UserImagePicker.currentState?.pickedImage;

  var destinations = [];
  // final _userImagePicker = new UserImagePicker();

  @override
  void dispose() {
    _semesterController.dispose();
    _myAddressController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (get_key_UserImagePicker_pickedImage == null) {
      print('No image picked');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('No image picked'),
        ),
      );
      return;
    }

    // Tilføj bruger til user collection i Firestore.
    final ref = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child(authResult!.user!.uid)
        .child("profile_image.jpg");

    await ref
        .putFile(get_key_UserImagePicker_pickedImage!)
        .whenComplete(() => null);

    final String profilePictureUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(authResult!.user!.uid)
        .set({
      "semester": _semesterController.text.trim(),
      "profile_picture_url": profilePictureUrl,
      "my_address": _myAddressController.text.trim(),
      "destination": _destinationController.text.trim(),
    }); // her skal vi tilføje flere variabler.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 32, 40, 35),
            Color.fromARGB(255, 26, 51, 76)
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon her sæt vores eget ind:
                  // ImageIcon(
                  //   AssetImage(
                  //       "C:/Users/gusta/Documents/statistik/StudentSwap/assets/studentSwapLogo.png"),
                  //   color: Colors.white,
                  //   size: 190,
                  // ),

                  Text("Join the StudentSwap family",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Colors.white,
                      )),

                  //Welcome
                  SizedBox(height: 15),
                  Text(
                    "Register below with your details!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 25),

                  UserImagePicker(key: key_UserImagePicker),

                  SizedBox(height: 25),

                  //Semester textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller:
                          _semesterController, //What the user put in the textfield
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Semester',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //My Address textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller:
                          _myAddressController, //What the user put in the textfield
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'My Address',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //Their country textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller:
                          _destinationController, //What the user put in the textfield
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Destination',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //sign up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I am a member! ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
