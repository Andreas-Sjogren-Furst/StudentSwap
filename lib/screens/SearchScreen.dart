import 'package:flutter/material.dart';
import 'package:login_page/models/ApartmentCard.dart';

class SearchScreen extends StatelessWidget {

  // Sample data
  final apartmentList = [Apartment(city: "Amsterdam", address: "Julianaplein 6, 1097 DN", apartmentImage: "apartment1", profileImage: "profile1"),
                        Apartment(city: "Amsterdam", address: "Osdorpplein 372A, 1068 EV", apartmentImage: "apartment2", profileImage: "profile2"),
                        Apartment(city: "Amsterdam", address: "Julianaplein 6, 1097 DN", apartmentImage: "apartment1", profileImage: "profile1"),
                        Apartment(city: "Amsterdam", address: "Osdorpplein 372A, 1068 EV", apartmentImage: "apartment2", profileImage: "profile2"),];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      style: TextStyle(color: Colors.grey, fontSize: 14.0, fontFamily: "Poppins", fontWeight: FontWeight.w200),
                    ),
                    Text(
                      "Jefferson",
                      style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/sample/profile2.jpg"),
                  radius: 27.0,
                )
              ],
            ),
            const SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 3,
                  // TODO: Style TextField
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),

                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(36.0, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.0 )),
                        color: Colors.grey[300],
                        // color: Color.fromRGBO(242, 242, 243, 1.0),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.settings),
                        color: Colors.blueGrey,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 40.0),
            const Text(
              "Accommodation",
              style: TextStyle(fontFamily: "Poppins", fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
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


