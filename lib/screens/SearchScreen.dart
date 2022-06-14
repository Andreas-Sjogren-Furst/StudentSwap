import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/widgets/Apartment.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Sample data
  final apartmentList = [Apartment(city: "Amsterdam", address: "Julianaplein 6, 1097 DN", apartmentImage: "apartment1", profileImage: "profile1"),
                        Apartment(city: "Amsterdam", address: "Osdorpplein 372A, 1068 EV", apartmentImage: "apartment2", profileImage: "profile2"),
                        Apartment(city: "Amsterdam", address: "Julianaplein 6, 1097 DN", apartmentImage: "apartment1", profileImage: "profile1"),
                        Apartment(city: "Amsterdam", address: "Osdorpplein 372A, 1068 EV", apartmentImage: "apartment2", profileImage: "profile2"),
                        Apartment(city: "Amsterdam", address: "Julianaplein 6, 1097 DN", apartmentImage: "apartment1", profileImage: "profile1"),
                        Apartment(city: "Amsterdam", address: "Osdorpplein 372A, 1068 EV", apartmentImage: "apartment2", profileImage: "profile2"),
                        Apartment(city: "Amsterdam", address: "Julianaplein 6, 1097 DN", apartmentImage: "apartment1", profileImage: "profile1"),
                        Apartment(city: "Amsterdam", address: "Osdorpplein 372A, 1068 EV", apartmentImage: "apartment2", profileImage: "profile2"),];

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  late String _profileUrl;

  void initState() async {
    super.initState();

    db.collection("users").doc(user?.uid);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
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
                      style: TextStyle(color: Colors.grey, fontSize: 14.0, fontFamily: "Poppins", fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Jefferson", // TODO: Get username from Firebase"${user?.displayName}"
                      style: TextStyle(color: Colors.black, fontSize: 24.0, fontFamily: "Poppins", fontWeight: FontWeight.bold ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/sample/profile2.jpg"),
                  radius: 27.0,
                )
              ],
            ),
            const SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  // TODO: Style TextField
                  child: SizedBox(
                    height: 45.0,
                    child: TextField(
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
                        labelText: 'Search',
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
                        borderRadius: const BorderRadius.all(Radius.circular(12.0 )),
                        color: Colors.grey[200],
                        // color: Color.fromRGBO(242, 242, 243, 1.0),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list_alt),
                        color: Colors.blueGrey,
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 15.0),
            const Text(
              "Accommodation",
              style: TextStyle(fontFamily: "Poppins", fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: apartmentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return apartmentList[index].getCard();
                  },

                )
            ),

          ],
        ),
      ),
    );
  }
}


