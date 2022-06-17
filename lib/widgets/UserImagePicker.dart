import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({Key? key}) : super(key: key);

  // File? get getPickedImage => pickedImage;

  // File imagePickFn(File pickedImage) {
  //   return pickedImage;
  // }

  @override
  State<UserImagePicker> createState() => UserImagePickerState();
}

class UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;

  File? get getPickedImage => pickedImage;

// TODO lav IF-else om man vil bruge kamera eller fra galleri.
  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 150); // TODO lavere kvalitet, således det fylder mindre.

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.pickedImage = imageTemp);
      // widget.imagePickFn(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.pickedImage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
          radius: 30,
          // Tjekker om billede er taget, hvis så ændrer til billedet.
          child: pickedImage != null
              ? Image.file(pickedImage!)
              : Icon(Icons.person, size: 30)),
      ElevatedButton(
          onPressed: pickImageFromCamera, child: Text("upload image")),
    ]);
  }
}
