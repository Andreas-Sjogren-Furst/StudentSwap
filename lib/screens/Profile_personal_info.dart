import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, dynamic>?> getdata(String documentId) async {
  var users = FirebaseFirestore.instance.collection('users');
  var userId = await users.doc(documentId).get();
  return userId.data();
}

void writedata(String documentId, String changeVar, String toVar) async {
  final users = FirebaseFirestore.instance.collection('users').doc(documentId);
  await users.update({changeVar: toVar});
}

class ProfileInfo extends StatefulWidget {
  String mainPhotoPath;
  ProfileInfo({Key? key, this.mainPhotoPath = ""}) : super(key: key);
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
  final mainPhotoRef = FirebaseStorage.instance
      .ref()
      .child("user_images")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("profileImage.jpg");
}

class _ProfileInfoState extends State<ProfileInfo> {
  getMainPhotoFromFirebase() {
    getData(userAuth).then((userData) => setState(() {
          widget.mainPhotoPath = userData?['profileImage'];
        }));
  }

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController profilePicture = TextEditingController();
  TextEditingController description = TextEditingController();
  var userAuth = FirebaseAuth.instance.currentUser!.uid;

  _ProfileInfoState() {
    getdata(userAuth).then((userData) => setState(() {
          firstName.text = userData?['firstName'];
          lastName.text = userData?['lastName'];
          country.text = userData?['myCountry'];
          address.text = userData?['myAddress'];
          email.text = userData?['Email'];
          gender.text = userData?['gender'];
          widget.mainPhotoPath = userData?['profileImage'];
          description.text = userData?['description'];
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMainPhotoFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal information'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                ListTile(
                                  title: const Text("Take a photo"),
                                  leading: Icon(
                                    Icons.add_a_photo_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onTap: () {
                                    setState(() async {
                                      Navigator.pop(context);
                                      getImageFromDevice(
                                          PhotoType.apartmentImage,
                                          gallery: false,
                                          mainRef: widget.mainPhotoRef);
                                      getMainPhotoFromFirebase();
                                    });
                                  },
                                ),
                                ListTile(
                                  title: const Text("Add photo"),
                                  leading: Icon(
                                    Icons.folder_copy_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onTap: () {
                                    setState(() async {
                                      Navigator.pop(context);
                                      await getImageFromDevice(
                                          PhotoType.apartmentImage,
                                          gallery: true,
                                          mainRef: widget.mainPhotoRef);
                                      getMainPhotoFromFirebase();
                                    });
                                  },
                                )
                              ],
                            );
                          });
                    });
                  },
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(widget.mainPhotoPath),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
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
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  readOnly: true,
                  controller: firstName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  readOnly: true,
                  controller: lastName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last name',
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: country,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Country',
                  ),
                  onFieldSubmitted: (String inputField) {
                    writedata(userAuth, 'myCountry', inputField);
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: address,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  onFieldSubmitted: (String inputField) {
                    writedata(userAuth, 'myAddress', inputField);
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                  onFieldSubmitted: (String inputField) {
                    writedata(userAuth, 'Email', inputField);
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: gender,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Gender',
                  ),
                  onFieldSubmitted: (String inputField) {
                    writedata(userAuth, 'gender', inputField);
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  controller: description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  onFieldSubmitted: (String inputField) {
                    writedata(userAuth, 'description', inputField);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

getImageFromDevice(PhotoType pt,
    {required bool gallery,
    Reference? mainRef,
    Reference? additionalRef}) async {
  var uuid = const Uuid();

  XFile? pickedFile = await ImagePicker().pickImage(
    source: gallery ? ImageSource.gallery : ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);

    if (pt.name.toString() == "apartmentImage") {
      await mainRef!.putFile(imageFile).whenComplete(() => null);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"profileImage": await mainRef.getDownloadURL()});
    } else {
      String id = uuid.v1();
      await additionalRef!
          .child(id)
          .putFile(imageFile)
          .whenComplete(() => null);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "additionalImages": FieldValue.arrayUnion(
            [await additionalRef.child(id).getDownloadURL()])
      });
    }
  }
}

// Removes photo from Firebase Storage and Firestore
removePhoto(String urlPath, Reference ref, PhotoType pt) async {
  var temp = urlPath.split("%2F");
  var pathStrings = temp[3].split("?");
  var path = pathStrings[0];

  final docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  Map<String, dynamic> updates = {};

  switch (pt) {
    case PhotoType.apartmentImage:
    // Doesn't work.
    /*updates = <String, dynamic>{
        "apartmentImage": FieldValue.delete(),
      };
      await ref.delete();
      break;*/

    case PhotoType.addtionalImages:
      updates = <String, dynamic>{
        "additionalImages": FieldValue.arrayRemove([urlPath]),
      };
      await ref.child(path).delete();
      break;
  }

  docRef.update(updates);
}

// Function to get the user's photos
Future<Map<String, dynamic>?> getData(String documentId) async {
  var users = FirebaseFirestore.instance.collection('users');
  var userId = await users.doc(documentId).get();
  return userId.data();
}

/* Enums */

// Identifies which photo type to use
enum PhotoType {
  apartmentImage,
  addtionalImages,
}

// Identifies which input to use
enum PhotoInput { camera, gallery }
