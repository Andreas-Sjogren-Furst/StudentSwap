import 'dart:collection';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/services/FirebaseMethods.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:login_page/widgets/Apartment.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search-screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String userName = "loading...";
  String searchKey = ""; // En by i search.
  List<String> GoingToKey = []; // ønsker af byer man vil til.
  String Semesterkey = ""; // Hvilket semester, any, spring, autumn,

  // Used for testing purposes
  String testSemester = "Any";
  String testApartment = "Any";

  final TextEditingController _searchController = TextEditingController();

  Stream streamQuery =
      FirebaseFirestore.instance.collection("users").snapshots();

  getData(String uid) async {
    final FirestoreUserReference =
        FirebaseFirestore.instance.collection("users");
    return await FirestoreUserReference.doc(uid).get();
  }

  Future<String> getUserName(String uid) async {
    final userDocument = await getData(uid);
    return userDocument['username'].toString();
  }

  String setGoingToKey(String semester) {
    Semesterkey = semester;
    return semester;
  }

  List<Apartment> apartmentsLists = [];
  // Sample data
  List<String> apartmentTypeWishes = [];

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  late String _profileUrl;

  void initState() {
    super.initState();
    db.collection("users").doc(user?.uid);
  }

  // Future<Apartment?> _getUserNames() async {
  //   dynamic userOne = await getData('VZfEnodgGN1bedOJtPWZ');
  //   dynamic userTwo = await getData('s0HetWSfOkuJi1mLCROZ');
  //   print(userOne['city']);
  //   return Apartment(
  //       city: await userOne['city'],
  //       address: await userOne['address'],
  //       apartmentImage: await userOne['apartmentImage'],
  //       profileImage: await userOne['profileImage'],
  //       savedFavorite: await userOne['savedFavorite'],
  //       goingTo: await userOne['goingTo'],
  //       userID: await userOne['userID'],
  //       semester: await userOne['semester'],
  //       appartmentType: await userOne['appartmentType']);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }

              getUserName(FirebaseMethods.userId).then((value) {
                return value;
              });

              for (var doc in snapshot.data!.docs) {
                Object? testmap = doc.data();
                LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));
                print("apartment list add");

                apartmentsLists.add(Apartment(
                    city: userMap['city'] ?? "not available",
                    address: userMap['address'] ?? "not available",
                    apartmentImage: userMap['apartmentImage'] ?? "no available",
                    profileImage: userMap['profileImage'] ?? "not available",
                    savedFavorite: userMap['savedFavorite'] ?? false,
                    goingTo: userMap["goingTo"] ?? ["test1", "test2"],
                    userID: userMap['userID'] ?? "not available",
                    semester: userMap['semester'] ?? "not available",
                    appartmentType:
                        userMap['appartmentType'] ?? "not available"));
              }
              // opdaterer apartmentlist med searchKey.TODO: Mangler at sortere efter lejligheder som kun vil til brugerens ejen by.
              apartmentsLists = apartmentsLists
                  .where((apartment) => apartment.city
                      .toLowerCase()
                      .contains(searchKey.toLowerCase()))
                  .where((apartment) =>
                      GoingToKey.isEmpty ||
                      GoingToKey.map(
                              (goingToKeyString) => goingToKeyString.toLowerCase())
                          .toList()
                          .contains(apartment.city.toLowerCase()))
                  .where((apartment) => apartment.semester
                      .toLowerCase()
                      .contains(Semesterkey.toLowerCase()))
                  .where((apartment) =>
                      apartmentTypeWishes.isEmpty ||
                      apartmentTypeWishes
                          .map((apartmentType) => apartmentType.toLowerCase())
                          .toList()
                          .contains(apartment.appartmentType.toLowerCase()))
                  .toList();

              // print("Apartsmentslist: ${apartmentsLists}");

              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Sample Data
                            Text(
                              "Welcome back!",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Jeff", // TODO: Get username from Firebase"${user?.displayName}"
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/sample/profile2.jpg"),
                          radius: 27.0,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          // TODO: Style TextField
                          child: SizedBox(
                            height: 45.0,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchKey = value;
                                  GoingToKey = [];
                                  testSemester = "";
                                  testApartment = "";
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:  const BorderSide(
                                      color: Colors.grey,
                                      width: 0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFEEEEEE),
                                labelText: 'Search for a city',
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                    fontSize: 16.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400
                                ),
                                prefixIcon: const Icon(Icons.search, color: Colors.grey,),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                color: Colors.grey[200],
                                // color: Color.fromRGBO(242, 242, 243, 1.0),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return FilterSheet(goingToKey: GoingToKey, semesterKey: testSemester, apartmentType: testApartment,); // TODO: apartmentType not working
                                      }
                                  ).then((value) => {
                                    setState(() {
                                      // Clear any previous search results
                                      _searchController.clear();
                                      searchKey = "";

                                      GoingToKey = value['city'];

                                      // Used for testing purposes
                                      testSemester = value['semester'];
                                      testApartment = value['apartmentType'];

                                      // TODO: Make keys exist in Firebase
                                      // Not implemnted yet. Keys doesn't exist in Firebase.
                                      // Semesterkey = value['semester'];
                                      // apartmentTypeWishes = value['apartmentType'];
                                    })

                                  });
                                },
                                icon: const Icon(Icons.filter_list_alt),
                                color: Colors.blueGrey,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    const Text(
                      "Accommodation",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                        child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: apartmentsLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return apartmentsLists[index].getCard();
                      },
                    )),
                  ],
                ),
              );
            }));
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    Key? key, this.goingToKey = const [], this.semesterKey = "Any", this.apartmentType = "Any",
  }) : super(key: key);

  final List<String> goingToKey;
  final String semesterKey;
  final String apartmentType;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {

  // List of cities to be displayed in the chips
  List<String> _cityChips = [];

  // List of semesters that are available
  List<bool> _semesterChipsBool = [true, false, false];
  final List<String> _semesterChips = ["Any", "Spring", "Autumn"];

  // List of apartment types that are available
  List<bool> _apartmentTypeChipsBool = [true, false, false];
  final List<String> _apartmentTypeChips = ["Any", "Dorm", "Apartment"];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _cityChips.addAll(widget.goingToKey);
    if(widget.semesterKey.isNotEmpty) {

      // Set all elements of semesterChipsBool to false
      _semesterChipsBool.setAll(0, [false,false,false]);

      // Set the correct element to true
      _semesterChipsBool[_semesterChips.indexWhere((element) => element.contains(widget.semesterKey))] = true;

    }
    if(widget.apartmentType.isNotEmpty) {
      // Set all elements of apartmentTypeChipsBool to false
      _apartmentTypeChipsBool.setAll(0, [false,false,false]);

      // Set the correct element to true
      _apartmentTypeChipsBool[_apartmentTypeChips.indexWhere((element) => element.contains(widget.apartmentType))] = true;
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontFamily: "Poppins", color: Colors.black),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close_rounded),
                  iconSize: 24.0,
                ),
                const Text("Filters",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                TextButton(
                  onPressed: () {
                    var values = {
                      "city": _cityChips,
                      "semester": _semesterChips[(_semesterChipsBool.indexWhere((element) => element == true)).toInt()],
                      "apartmentType": _apartmentTypeChips[(_apartmentTypeChipsBool.indexWhere((element) => element == true)).toInt()],
                    };

                    Navigator.pop(context, values);
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15.0, fontFamily: "Poppins", fontWeight: FontWeight.w400),
                  ),
                  child: const Text("Done"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0,),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    //setState(() {
                      // searchKey = value;
                    //});
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _cityChips.add(value);
                      _searchController.clear();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFEEEEEE),
                    labelText: 'Search for a city',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 18.0),
                _cityChips.isNotEmpty ? SizedBox(
                  height: 32.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cityChips.length,
                    itemBuilder: (context, index) =>(
                       Chip(
                         label: Text(_cityChips[index]),
                         deleteIcon: const Icon(Icons.clear, size: 16.0,),
                         backgroundColor: Theme.of(context).primaryColorLight,
                         deleteIconColor: Theme.of(context).primaryColor,
                         onDeleted: () {
                           setState(() {
                               _cityChips.removeAt(index);
                           });
                         },
                       )
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 3.0);
                    },
                  ),
                ) : Container(),
                const Divider(height: 30.0,),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Semester", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 32.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ChoiceChip(
                          label: const Text("Any"),
                          selected: _semesterChipsBool[0],
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: _semesterChipsBool[0] ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                          onSelected: (bool _newValue) {
                            setState((){
                              if (_newValue) {
                                _semesterChipsBool[0] = true;
                                _semesterChipsBool[1] = false;
                                _semesterChipsBool[2] = false;
                              }
                            });
                          }
                        ),
                        const SizedBox(width: 8.0,),
                        ChoiceChip(
                            label: const Text("Spring"),
                            selected: _semesterChipsBool[1],
                            selectedColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: _semesterChipsBool[1] ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            onSelected: (bool _newValue) {
                              setState((){
                                if (_newValue) {
                                  _semesterChipsBool[0] = false;
                                  _semesterChipsBool[1] = true;
                                  _semesterChipsBool[2] = false;
                                }
                              });
                            }
                        ),
                        const SizedBox(width: 8.0,),
                        ChoiceChip(
                            label: const Text("Autumn"),
                            selected: _semesterChipsBool[2],
                            selectedColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: _semesterChipsBool[2] ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            onSelected: (bool _newValue) {
                              setState((){
                                if (_newValue) {
                                  _semesterChipsBool[0] = false;
                                  _semesterChipsBool[1] = false;
                                  _semesterChipsBool[2] = true;
                                }
                              });
                            }
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 30.0,),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Apartment Type", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 32.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ChoiceChip(
                            label: const Text("Any"),
                            selected: _apartmentTypeChipsBool[0],
                            selectedColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: _apartmentTypeChipsBool[0] ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            onSelected: (bool _newValue) {
                              setState((){
                                if (_newValue) {
                                  _apartmentTypeChipsBool[0] = true;
                                  _apartmentTypeChipsBool[1] = false;
                                  _apartmentTypeChipsBool[2] = false;
                                }
                              });
                            }
                        ),
                        const SizedBox(width: 8.0,),
                        ChoiceChip(
                            label: Text("Dorm"),
                            selected: _apartmentTypeChipsBool[1],
                            selectedColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: _apartmentTypeChipsBool[1] ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            onSelected: (bool _newValue) {
                              setState((){
                                if (_newValue) {
                                  _apartmentTypeChipsBool[0] = false;
                                  _apartmentTypeChipsBool[1] = true;
                                  _apartmentTypeChipsBool[2] = false;
                                }
                              });
                            }
                        ),
                        const SizedBox(width: 8.0,),
                        ChoiceChip(
                            label: Text("Apartment"),
                            selected: _apartmentTypeChipsBool[2],
                            selectedColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: _apartmentTypeChipsBool[2] ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            onSelected: (bool _newValue) {
                              setState((){
                                if (_newValue) {
                                  _apartmentTypeChipsBool[0] = false;
                                  _apartmentTypeChipsBool[1] = false;
                                  _apartmentTypeChipsBool[2] = true;
                                }
                              });
                            }
                        ),
                      ],
                    ),
                  ),
                )
            ]),
          ),
        ],
      ),
    );
  }
}
