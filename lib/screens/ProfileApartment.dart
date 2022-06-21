import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// Main widget
class ProfileApartment extends StatefulWidget {
  static const routeName = "/profile-apartment";
  const ProfileApartment({Key? key}) : super(key: key);

  @override
  State<ProfileApartment> createState() => _ProfileApartmentState();
}

class _ProfileApartmentState extends State<ProfileApartment> {

  final userAuth = FirebaseAuth.instance.currentUser!.uid;
  String mainPhotoPath = "";
  List<String> additionalPhotos = [];

  _ProfileApartmentState() {
    getData(userAuth).then((userData) => setState(() {

      // Get URL to main apartment photo
      mainPhotoPath = userData?['apartmentImage'];

      // Get all additional URLs
      Map<String, dynamic> additionalMap = userData?['additionalImages'];
      additionalPhotos = List.from(additionalMap.values);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24.0,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Text(
                          'Apartment Photos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopPhoto(mainPhotoPath: mainPhotoPath,),
                    PhotoGrid(additionalPhotosPath: additionalPhotos,),
                  ],
                ),
            ),
              )],
          ),
        ),
      )

    );
  }
}

// Main photo at the top
//ignore: must_be_immutable
class TopPhoto extends StatefulWidget {
  TopPhoto({
    Key? key,
    this.mainPhotoPath = "",
  }) : super(key: key);

  String mainPhotoPath;

  // Reference to main apartment photo
  final mainPhotoRef = FirebaseStorage.instance
      .ref()
      .child("user_images")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("mainApartmentPhoto.jpg");

  @override
  State<TopPhoto> createState() => _TopPhotoState();
}

class _TopPhotoState extends State<TopPhoto> {

  var userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getMainPhotoFromFirebase();
  }

  getMainPhotoFromFirebase() {
    getData(userID).then((userData) => setState(() {
      widget.mainPhotoPath = userData?['apartmentImage'];
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) =>
                    ImageDialog(
                      ni: NetworkImage(widget.mainPhotoPath),
                      ref: widget.mainPhotoRef,
                      main: PhotoType.apartmentImage,
                ));
          },
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child:
              //mainPhotoPath.isNotEmpty ?
              Image(
                  image: NetworkImage(widget.mainPhotoPath),
                  height: MediaQuery.of(context).size.height/3,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      SizedBox(
                        height: MediaQuery.of(context).size.height/3,
                        child: Icon(
                          Icons.error,
                          size: 128.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
              )
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              color: const Color.fromARGB(100, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Main photo",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0),
                      ),
                      Text("This is the first photo other users see",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14))
                    ],
                  ),
                  IconButton(
                    onPressed: () {

                      setState(() {

                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  ListTile(
                                    title: const Text("Take a photo"),
                                    leading: Icon(Icons.add_a_photo_rounded, color: Theme.of(context).primaryColor,),
                                    onTap: () {
                                      setState(() async {
                                        Navigator.pop(context);
                                        getImageFromDevice(PhotoType.apartmentImage, gallery: false, mainRef: widget.mainPhotoRef);
                                        getMainPhotoFromFirebase();
                                      });
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("Add photo"),
                                    leading: Icon(Icons.folder_copy_rounded, color: Theme.of(context).primaryColor,),
                                    onTap: () {
                                      setState(() async {
                                        Navigator.pop(context);
                                        await getImageFromDevice(PhotoType.apartmentImage, gallery: true, mainRef: widget.mainPhotoRef);
                                        getMainPhotoFromFirebase();
                                      });
                                    },
                                  )
                                ],
                              );
                            }
                        );

                      });

                    }, // TODO: Edit main photo
                    icon: const Icon(Icons.edit),
                    iconSize: 24,
                    color: Colors.white,
                  )
                ],
              )),
        )
      ],
    );
  }
}


// Grid of photos at the bottom
//ignore: must_be_immutable
class PhotoGrid extends StatefulWidget {
  PhotoGrid({
    Key? key,
    this.additionalPhotosPath = const [],
  }) : super(key: key);

  //Map<String?, dynamic>? additionalPhotosPath;
  List<String>? additionalPhotosPath;

  var additionalPhotoRef = FirebaseStorage.instance
      .ref()
      .child("user_images")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("additional_photos");

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          Map<String, dynamic> data = {};
          widget.additionalPhotosPath = data['additionalImages'] != null ? List.from(data['additionalImages']) : [];
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          widget.additionalPhotosPath = data['additionalImages'] != null ? List.from(data['additionalImages']) : [];
        }



        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Additional photos"),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      title: const Text("Take a photo"),
                                      leading: Icon(
                                        Icons.add_a_photo_rounded, color: Theme
                                          .of(context)
                                          .primaryColor,),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await getImageFromDevice(
                                            PhotoType.addtionalImages,
                                            gallery: false,
                                            additionalRef: widget.additionalPhotoRef);
                                        setState(()  {
                                          // Don't remove! Used to update list of photos.
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: const Text("Add photo"),
                                      leading: Icon(
                                        Icons.folder_copy_rounded, color: Theme
                                          .of(context)
                                          .primaryColor,),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await getImageFromDevice(
                                            PhotoType.addtionalImages,
                                            gallery: true,
                                            additionalRef: widget.additionalPhotoRef);
                                        setState(()  {
                                          // Don't remove! Used to update list of photos.
                                        });
                                      },
                                    )
                                  ],
                                );
                              }
                          );
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: const Text(
                        "Edit",
                      ))
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      childAspectRatio: 1.0),
                  padding: EdgeInsets.zero,
                  itemCount: widget.additionalPhotosPath != null  ? widget.additionalPhotosPath!.length : 0, //widget.additionalPhotosPath?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) =>
                                ImageDialog(
                                  ni: NetworkImage(widget.additionalPhotosPath![index]),
                                  ref: widget.additionalPhotoRef,
                                  main: PhotoType.addtionalImages,
                                ),
                            );
                        setState(() {
                          // Used for updating user-actions
                        });
                      },
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 3,
                          child: Image(
                              image:
                              NetworkImage(widget.additionalPhotosPath![index]),
                              fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height/3)*2,
                                  child: Icon(
                                    Icons.error,
                                    size: 128.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )),
                          )
                      );
                  })
            ],
          ),
        );
      }
    );
  }
}

// Dialog to show photos when clicked
class ImageDialog extends StatefulWidget {
  const ImageDialog({Key? key, this.ni= const NetworkImage(""), required this.ref, required this.main}) : super(key: key);

  final NetworkImage ni;
  final Reference ref;
  final PhotoType main;

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Stack(
          children: [
            Image(
              image: widget.ni,
              fit: BoxFit.contain,
            ),
            widget.main==PhotoType.addtionalImages ? Positioned(
                bottom: 10,
                right: 10,
                child:
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(150, 0, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                    child: IconButton(
                        onPressed: () async {

                          var result = await showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Delete this photo?"),
                                content: const Text("Are you sure you want to delete this photo? \n\nThis action cannot be undone. "),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],

                          ));

                          if (result) {
                            await removePhoto(widget.ni.url, widget.ref, PhotoType.addtionalImages);
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        },
                        icon: const Icon(Icons.delete),
                        iconSize: 24.0,
                        color: Colors.red,
                    ))
            ) : Wrap(),
            Positioned(
                top: 10,
                left: 10,
                child:  Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(150, 0, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 24.0,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
            ),
        ]),
    );
  }
}


/* Functions */

// Gets photo from either gallery or camera
getImageFromDevice(PhotoType pt,  {required bool gallery ,Reference? mainRef, Reference? additionalRef}) async {

  var uuid = const Uuid();

  XFile? pickedFile = await ImagePicker().pickImage(
    source: gallery ? ImageSource.gallery : ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);

    if (pt.name.toString() == "apartmentImage") {
      await mainRef!.putFile(imageFile)
          .whenComplete(() => null);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "apartmentImage" : await mainRef.getDownloadURL()
      });

    } else {
      String id = uuid.v1();
      await additionalRef!.child(id).putFile(imageFile)
          .whenComplete(() => null);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "additionalImages" : FieldValue.arrayUnion([await additionalRef.child(id).getDownloadURL()])
      });
    }
  }
}

// Removes photo from Firebase Storage and Firestore
removePhoto(String urlPath, Reference ref, PhotoType pt) async {

  var temp = urlPath.split("%2F");
  var pathStrings = temp[3].split("?");
  var path = pathStrings[0];

  final docRef = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
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
enum PhotoInput {
  camera,
  gallery
}