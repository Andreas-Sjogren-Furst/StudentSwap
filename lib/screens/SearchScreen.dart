import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/services/FirebaseMethods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:login_page/widgets/Apartment.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search-screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchKey = "";
  List<String> GoingToKey = [];
  String Semesterkey = "";
  Stream streamQuery =
      FirebaseFirestore.instance.collection("users").snapshots();

  getData(String uid) async {
    final FirestoreUserReference =
        FirebaseFirestore.instance.collection("users");
    return await FirestoreUserReference.doc(uid).get();
  }

  String setGoingToKey(String semester) {
    Semesterkey = semester;
    return semester;
  }

  List<Apartment> apartmentsLists = [];
  // Sample data

  final apartmentList = [
    Apartment(
        city: "Amsterdam",
        address: "Julianaplein 6, 1097 DN",
        apartmentImage: "apartment1",
        profileImage: "profile1",
        savedFavorite: false,
        goingTo: ['København', 'Stockholm', 'Nuuk'],
        userID: 'Gustav'),
    Apartment(
        city: "Amsterdam",
        address: "Osdorpplein 372A, 1068 EV",
        apartmentImage: "apartment2",
        profileImage: "profile2",
        savedFavorite: false,
        goingTo: ['Stockholm', 'Rio', 'New York'],
        userID: 'Sven'),
  ];

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  late String _profileUrl;

  void initState() {
    super.initState();
    db.collection("users").doc(user?.uid);
  }

  Future<Apartment?> _getUserNames() async {
    dynamic userOne = await getData('VZfEnodgGN1bedOJtPWZ');
    dynamic userTwo = await getData('s0HetWSfOkuJi1mLCROZ');
    print(userOne['city']);
    return Apartment(
        city: await userOne['city'],
        address: await userOne['address'],
        apartmentImage: await userOne['apartmentImage'],
        profileImage: await userOne['profileImage'],
        savedFavorite: await userOne['savedFavorite'],
        goingTo: await userOne['goingTo'],
        userID: await userOne['userID']);
  }

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
                    goingTo: ["test1", "test2"],
                    userID: userMap['userID'] ?? "not available"));
              }
              // opdaterer apartmentlist med searchKey.
              apartmentsLists = apartmentsLists
                  .where((apartment) => apartment.city
                      .toLowerCase()
                      .contains(searchKey.toLowerCase()))
                  .where((apartment) =>
                      GoingToKey.isEmpty ||
                      GoingToKey.map((key) => key.toLowerCase())
                          .toList()
                          .contains(apartment.city.toLowerCase()))
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
                              "Jefferson", // TODO: Get username from Firebase"${user?.displayName}"
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
                              onChanged: (value) {
                                setState(() {
                                  searchKey = value;
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
                                        return FilterSheet();
                                      }
                                  );
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
  }) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {

  List<String> _cityChips = [];
  var _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontFamily: "Poppins", color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 16.0),
            SizedBox(
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
            ),
            const Divider(height: 24.0,),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Semester", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
            ),
            SizedBox(
              height: 32.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ChoiceChip(label: Text("Any"), selected: true),
                  ChoiceChip(label: Text("Fall"), selected: false),
                  ChoiceChip(label: Text("Autumn"), selected: false),
                ],
              ),
            )
        ]),
      ),
    );
  }
}
