import 'dart:collection';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/services/FirebaseMethods.dart';
import 'package:dropdown_search/dropdown_search.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

import 'package:login_page/widgets/Apartment.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search-screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late var currentUserName = 'Johnson';
  String userName = "loading...";
  String searchKey = ""; // En by i search.
  List<String> GoingToKey = []; // ønsker af byer man vil til.
  String Semesterkey = ""; // Hvilket semester, any, spring, autumn,
  List<String> years = [];

  // Used for testing purposes
  String testSemester = "Any";
  String testApartment = "Any";

  final TextEditingController _searchController = TextEditingController();

  Stream streamQuery =
      FirebaseFirestore.instance.collection("users").snapshots();

  getCurrentUser() {
    return currentUserName;
  }

  getData(String uid) async {
    final FirestoreUserReference =
        FirebaseFirestore.instance.collection("users");
    return await FirestoreUserReference.doc(uid).get();
  }

  String setGoingToKey(String semester) {
    Semesterkey = semester;
    return semester;
  }

  // Sample data
  String apartmentTypeWishes = "Any";

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  late String _profileUrl;

  void initState() {
    super.initState();
    db.collection("users").doc(user?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitSquareCircle(
                    color: Colors.pink,
                    size: 80,
                  ),
                );
              }

              var currentUserFavorties = [];
              List<Apartment> apartmentsLists = [];
              currentUserName = "loading";
              String currentUserProfilePicture = "";

              for (var doc in snapshot.data!.docs) {
                Object? testmap = doc.data();
                LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));

                if (userMap["userID"] == currentUserId) {
                  currentUserFavorties =
                      userMap["favorites"] ?? []; // Hent favoritter
                  currentUserName = userMap["firstName"] ?? "lolcat";
                  currentUserProfilePicture =
                      userMap["profileImage"] ?? "no Image";
                }
              }

              for (var doc in snapshot.data!.docs) {
                Object? testmap = doc.data();
                LinkedHashMap<dynamic, dynamic> testlinked =
                    testmap as LinkedHashMap<dynamic, dynamic>;
                Map<String, dynamic> userMap =
                    testlinked.map((a, b) => MapEntry(a, b));

                if (userMap["userID"] != currentUserId ||
                    userMap["apartmentImage"] != null) {
                  apartmentsLists.add(Apartment(

                    description: userMap['description'],
                    city: userMap['myCountry'] ?? "not available",
                    address: userMap['myAddress'] ?? "not available",
                    apartmentImage:
                        userMap['apartmentImage'] ?? "not available",
                    profileImage: userMap['profileImage'] ?? "not available",
                    savedFavorite:
                        (currentUserFavorties.contains(userMap["userID"]))
                            ? true
                            : false, // check om bruger har gemt denne bruger.
                    goingTo: userMap["goingTo"] ?? ["test1", "test2"],
                    userID: userMap['userID'] ?? "not available",
                    semester: userMap['semester'] ?? "not available",
                    appartmentType:
                        userMap['appartmentType'] ?? "not available",
                    year: userMap['year'] ?? "not available",
                    currentUser: getCurrentUser(),
                  ));
                }
              }              // opdaterer apartmentlist med searchKey.

              apartmentsLists = apartmentsLists
                  .where((apartment) =>
                      apartment.city.toLowerCase().contains(searchKey.toLowerCase()) &&
                      apartment.city != "not available")
                  .where((apartment) =>
                      apartment.apartmentImage != "not available")
                  .toList()
                  .where((apartment) =>
                      GoingToKey.isEmpty ||
                      GoingToKey.map((goingToKeyString) => goingToKeyString.toLowerCase())
                          .toList()
                          .contains(apartment.city.toLowerCase()))
                  .where((apartment) =>
                      Semesterkey.toLowerCase().contains("any") ||
                      apartment.semester
                          .toLowerCase()
                          .contains(Semesterkey.toLowerCase()))
                  .where((apartment) =>
                      apartmentTypeWishes.toLowerCase().contains("any") ||
                      apartment.appartmentType
                          .toLowerCase()
                          .contains(apartmentTypeWishes.toLowerCase()))
                  .where((appartment) => years.isEmpty || years.map((year) => year.toLowerCase()).toList().contains(appartment.year.toLowerCase()))
                  .toList();

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
                          children: [
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
                              currentUserName, // TODO: Get username from Firebase"${user?.displayName}"
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(currentUserProfilePicture),
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
                                  years = [];
                                  testSemester = "";
                                  testApartment = "";
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.5),
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
                                labelText: 'Search for a country',
                                labelStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
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
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return FilterSheet(
                                          goingToKey: GoingToKey,
                                          semesterKey: testSemester,
                                          apartmentType: testApartment,
                                          year: years,
                                        ); // TODO: apartmentType not working
                                      }).then((value) => {
                                        setState(() {
                                          // Clear any previous search results
                                          _searchController.clear();
                                          searchKey = "";

                                          GoingToKey = value['city'];

                                          // Used for testing purposes
                                          testSemester = value['semester'];
                                          testApartment =
                                              value['apartmentType'];

                                          List<int> tempYears =
                                              List.from(value['year']);
                                          years = tempYears
                                              .map((element) =>
                                                  element.toString())
                                              .toList();

                                          // TODO: Make keys exist in Firebase
                                          // Not implemnted yet. Keys doesn't exist in Firebase.
                                          Semesterkey = value['semester'];
                                          apartmentTypeWishes =
                                              value['apartmentType'];
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
    Key? key,
    this.goingToKey = const [],
    this.year = const [],
    this.semesterKey = "Any",
    this.apartmentType = "Any",
  }) : super(key: key);

  final List<String> goingToKey;
  final List<String> year;
  final String semesterKey;
  final String apartmentType;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // List of cities to be displayed in the chips
  List<String> _cityChips = [];

  // List of years
  List<String> _years = [];
  List<bool> _yearChips = [false, false, false, false, false];

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

    // Get current year and the following four years
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 5; i++) {
      _years.add((currentYear + i).toString());
    }

    if (widget.year.isNotEmpty) {
      // Set all elements of semesterChipsBool to false
      _yearChips.setAll(0, [false, false, false, false, false]);

      // Get the selected years
      for (int i = 0; i < widget.year.length; i++) {
        if (_years[i] == widget.year[i]) {
          _yearChips[i] = true;
        }
      }
    }
    if (widget.semesterKey.isNotEmpty) {
      // Set all elements of semesterChipsBool to false
      _semesterChipsBool.setAll(0, [false, false, false]);

      // Set the correct element to true
      _semesterChipsBool[_semesterChips.indexWhere(
          (element) => element.contains(widget.semesterKey))] = true;
    }
    if (widget.apartmentType.isNotEmpty) {
      // Set all elements of apartmentTypeChipsBool to false
      _apartmentTypeChipsBool.setAll(0, [false, false, false]);

      // Set the correct element to true
      _apartmentTypeChipsBool[_apartmentTypeChips.indexWhere(
          (element) => element.contains(widget.apartmentType))] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      DefaultTextStyle(
        style: const TextStyle(fontFamily: "Poppins", color: Colors.black),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 24.0,
                  ),
                  const Text("Filters",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                  TextButton(
                    onPressed: () {
                      // Get the selected years
                      List<int> selectedYears = [];
                      for (int i = 0; i < _years.length; i++) {
                        if (_yearChips[i]) {
                          selectedYears.add(int.parse(_years[i]));
                        }
                      }

                      // Values to be returned
                      var values = {
                        "city": _cityChips,
                        "year": selectedYears,
                        "semester": _semesterChips[(_semesterChipsBool
                            .indexWhere((element) => element == true)).toInt()],
                        "apartmentType": _apartmentTypeChips[
                            (_apartmentTypeChipsBool.indexWhere(
                                (element) => element == true)).toInt()],
                      };

                      Navigator.pop(context, values);
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400),
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
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {},
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
                        labelText: 'Search for a country',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    _cityChips.isNotEmpty
                        ? SizedBox(
                            height: 32.0,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _cityChips.length,
                              itemBuilder: (context, index) => (Chip(
                                label: Text(_cityChips[index]),
                                deleteIcon: const Icon(
                                  Icons.clear,
                                  size: 16.0,
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                deleteIconColor: Theme.of(context).primaryColor,
                                onDeleted: () {
                                  setState(() {
                                    _cityChips.removeAt(index);
                                  });
                                },
                              )),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(width: 3.0);
                              },
                            ),
                          )
                        : Container(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Year",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                          height: 32.0,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return FilterChip(
                                  label: Text(_years[index].toString()),
                                  selected: _yearChips[index],
                                  selectedColor: Theme.of(context).primaryColor,
                                  checkmarkColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: _yearChips[index]
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                  onSelected: (bool _newValue) {
                                    setState(() {
                                      _yearChips[index] = _newValue;
                                    });
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  width: 8.0,
                                );
                              },
                              itemCount: _years.length)),
                    ),
                    const Divider(
                      height: 30.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Semester",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0)),
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
                                  color: _semesterChipsBool[0]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                onSelected: (bool _newValue) {
                                  setState(() {
                                    if (_newValue) {
                                      _semesterChipsBool[0] = true;
                                      _semesterChipsBool[1] = false;
                                      _semesterChipsBool[2] = false;
                                    }
                                  });
                                }),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ChoiceChip(
                                label: const Text("Spring"),
                                selected: _semesterChipsBool[1],
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color: _semesterChipsBool[1]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                onSelected: (bool _newValue) {
                                  setState(() {
                                    if (_newValue) {
                                      _semesterChipsBool[0] = false;
                                      _semesterChipsBool[1] = true;
                                      _semesterChipsBool[2] = false;
                                    }
                                  });
                                }),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ChoiceChip(
                                label: const Text("Autumn"),
                                selected: _semesterChipsBool[2],
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color: _semesterChipsBool[2]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                onSelected: (bool _newValue) {
                                  setState(() {
                                    if (_newValue) {
                                      _semesterChipsBool[0] = false;
                                      _semesterChipsBool[1] = false;
                                      _semesterChipsBool[2] = true;
                                    }
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 30.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Apartment Type",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0)),
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
                                  color: _apartmentTypeChipsBool[0]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                onSelected: (bool _newValue) {
                                  setState(() {
                                    if (_newValue) {
                                      _apartmentTypeChipsBool[0] = true;
                                      _apartmentTypeChipsBool[1] = false;
                                      _apartmentTypeChipsBool[2] = false;
                                    }
                                  });
                                }),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ChoiceChip(
                                label: Text("Dorm"),
                                selected: _apartmentTypeChipsBool[1],
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color: _apartmentTypeChipsBool[1]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                onSelected: (bool _newValue) {
                                  setState(() {
                                    if (_newValue) {
                                      _apartmentTypeChipsBool[0] = false;
                                      _apartmentTypeChipsBool[1] = true;
                                      _apartmentTypeChipsBool[2] = false;
                                    }
                                  });
                                }),
                            const SizedBox(
                              width: 8.0,
                            ),
                            ChoiceChip(
                                label: Text("Apartment"),
                                selected: _apartmentTypeChipsBool[2],
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color: _apartmentTypeChipsBool[2]
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                onSelected: (bool _newValue) {
                                  setState(() {
                                    if (_newValue) {
                                      _apartmentTypeChipsBool[0] = false;
                                      _apartmentTypeChipsBool[1] = false;
                                      _apartmentTypeChipsBool[2] = true;
                                    }
                                  });
                                }),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    ]);
  }
}
