import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/screens/login/country.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_page/screens/TabsScreen.dart';
import 'package:login_page/widgets/UserImagePicker.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; //The package from pub.dev
import 'register_page.dart';

class RegisterPage2 extends StatefulWidget {
  static final routeName = "/register-page2";

  @override
  State<RegisterPage2> createState() => _RegisterPageState2();
}

class _RegisterPageState2 extends State<RegisterPage2> {
  final key_UserImagePicker = new GlobalKey<UserImagePickerState>();

  static UserCredential?
      authResult; // To get the user UID . TODO: null check safety.

  final List<String> semester = [
    'Spring - 2022',
    'Fall - 2022',
    'Spring - 2023',
    'Fall - 2023',
    'Spring - 2024',
    'Fall - 2024',
    'Spring - 2025',
    'Fall - 2025',
  ];

  Country countries =
      Country(); //calling all the countries from the other class

  final List<String> gender = [
    'Male',
    'Female',
    'Non-Binary',
  ];

  String? Semester;
  String? myCountry;
  List<dynamic> goingTo = [];
  String? Gender;

  // text controllers
  final _semesterController = TextEditingController();
  final _myCountryController = TextEditingController();
  final _destinationController = TextEditingController();
  final _myAddressController = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _gender = TextEditingController();

  // To get the user UID . TODO: null check safety.
  File? get get_key_UserImagePicker_pickedImage =>
      key_UserImagePicker.currentState?.pickedImage;

  @override
  void dispose() {
    //used to hold it clean
    _semesterController.dispose();
    _myCountryController.dispose();
    _destinationController.dispose();
    _myAddressController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _gender.dispose();
    super.dispose();
  } // To get the user UID . TODO: null check safety.

  Future signUp() async {
    //method to signup with all the informations
    if (passwordConfirmed() != null) {
      authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: RegisterPageState.emailController.text.trim(),
        password: RegisterPageState.passwordController.text.trim(),
      );

      if (get_key_UserImagePicker_pickedImage == null) {
        print('No image picked');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No image picked'),
          ),
        );
        return;
      }

      // Tilføj bruger til user collection i Firestore med billedet.
      final ref = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child(authResult!.user!.uid)
          .child("profile_image.jpg");

      await ref
          .putFile(get_key_UserImagePicker_pickedImage!)
          .whenComplete(() => null);

      final String profilePictureUrl = await ref.getDownloadURL();

      await FirebaseFirestore
          .instance //tilføjer alle vores vairable til firebasen nedenfor af det useren har valgt
          .collection("users")
          .doc(authResult!.user!.uid)
          .set({
        "Email": RegisterPageState.emailController.text.trim(),
        "userID": FirebaseAuth.instance.currentUser!.uid,
        "chats": [],
        "favorites": [],
        "semester": Semester!.split(' ')[0],
        "year": Semester!.split(' ')[2],
        "profileImage": profilePictureUrl,
        "myCountry": myCountry,
        "goingTo": goingTo,
        "gender": Gender,
        "myAddress": _myAddressController.text.trim(),
        "firstName": _firstName.text.trim(),
        "lastName": _lastName.text.trim(),
        "description": "",
        "additionalImages": [],
        "apartmentType": "Dorm",
        "description": "",
      });
      Navigator.pushNamed(context, TabScreen.routeName);
    }
  }

  bool passwordConfirmed() {
    //checker hvis passwordconfirmed passer med password
    if (RegisterPageState.passwordController.text.trim() ==
        RegisterPageState.confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
                  Text("Join the StudentSwap family",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Colors.white,
                      )),

                  //Welcome
                  SizedBox(height: 10),
                  Text(
                    "Register below with your details!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  UserImagePicker(key: key_UserImagePicker),

                  SizedBox(height: 20),

                  //Semester textfield hvor den nye package er brugt til dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(
                          ' The semester you want to go on exchange',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        items:
                            semester //Sørger for den tager listen ind med alle valgmulighederne
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                        value: Semester,
                        onChanged: (value) {
                          setState(() {
                            Semester = value as String;
                          });
                        }, //Opdaterer det der står i boxen ift. hvad man har valgt og når man ændrer sig valg
                        buttonHeight: 62,
                        buttonWidth: 370,
                        itemHeight: 62,
                        dropdownMaxHeight: 250,
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.white,
                        ),
                        searchController:
                            _semesterController, //bliver brugt til søgningen
                        searchInnerWidget: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _semesterController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText:
                                  'Search for Semester', //boksen der kommer ned hvor man kan søge
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
                        },
                        //Her sørger vi for at søge boksen bliver clearet når den bliver lukket
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _semesterController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //My Address textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(
                          ' My Country',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        items: countries.countries //Listen med alle lande
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: myCountry,
                        onChanged: (value) {
                          //Opdaterer det der står i boxen ift. hvad man har valgt og når man ændrer sig valg
                          setState(() {
                            myCountry = value as String;
                          });
                        },
                        buttonHeight: 62,
                        buttonWidth: 370,
                        itemHeight: 62,
                        dropdownMaxHeight: 250,
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.white,
                        ),
                        searchController: _myCountryController,
                        searchInnerWidget: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _myCountryController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText:
                                  'Search for Country', //Søge efter et land
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
                        },
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _myCountryController.clear();
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  //goingTo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(
                          ' Destination/Destinations',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        items: countries.countries.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            //Gør at man kan vælge flere items uden menuen lukker.
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, menuSetState) {
                                var _isSelected = goingTo.contains(item);
                                return InkWell(
                                  //krydser af i knapperne InkWell laver knapperne
                                  onTap: () {
                                    _isSelected
                                        ? goingTo.remove(
                                            item) //Fjerner item fra liste
                                        : goingTo
                                            .add(item); //Tilføj item til list
                                    //Opdaterer knappens text
                                    setState(
                                        () {}); //Problemer her hvis man ikke vælger i logisk rækkefølge kommer der fejl og den gider ikke vise
                                    //Opdatere menuen der kommer ned
                                    menuSetState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        _isSelected
                                            ? const Icon(
                                                Icons.check_box_outlined)
                                            : const Icon(
                                                Icons.check_box_outline_blank),
                                        const SizedBox(width: 16),
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                        value: goingTo.isEmpty
                            ? null
                            : goingTo
                                .last, //Adder elementet tilsidst i listen, hvis listen er tom
                        onChanged: (value) {},
                        buttonHeight: 62,
                        buttonWidth: 370,
                        itemHeight: 62,
                        dropdownMaxHeight: 250,
                        itemPadding: EdgeInsets.zero,
                        selectedItemBuilder: (context) {
                          return goingTo.map(
                            (item) {
                              return Container(
                                alignment: AlignmentDirectional.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  goingTo.join(
                                      ', '), //laver komma mellem hvert element
                                  style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            },
                          ).toList();
                        },
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.white,
                        ),
                        searchController: _destinationController,
                        searchInnerWidget: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _destinationController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText:
                                  'Search for Country', //Laver min søgefunktion igen
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
                        },
                        //Rydder menuen hvis man lukker den
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _myCountryController.clear();
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  //Gender textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(
                          ' Gender',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        items:
                            gender //Valgmulighederne ligger i listen "gender"
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                        value: Gender,
                        onChanged: (value) {
                          //Sørger for den bliver opdateret ud fra hvad useren vælger
                          setState(() {
                            Gender = value as String;
                          });
                        },
                        buttonHeight: 62,
                        buttonWidth: 370,
                        itemHeight: 62,
                        dropdownMaxHeight: 250,
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.white,
                        ),
                        searchController: _gender,
                        searchInnerWidget: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            //Søgningen i genders bliver lavet her
                            textCapitalization: TextCapitalization.sentences,
                            controller: _gender,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for Gender',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          //til at rydde søgemenuen
                          return (item.value.toString().contains(searchValue));
                        },
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _gender.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //FirstName standard
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller:
                          _firstName, //What the user put in the textfield
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Firstname',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //Lastname
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller:
                          _lastName, //What the user put in the textfield
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Lastname',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //address textfield
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
                        hintText: 'My City/Address',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
