import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class profile_apartment extends StatefulWidget {
  static const routeName = "/profile-apartment";

  const profile_apartment({Key? key}) : super(key: key);

  @override
  State<profile_apartment> createState() => _profile_apartmentState();
}

class _profile_apartmentState extends State<profile_apartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left_outlined),
                          iconSize: 32,
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(right: 32.0),
                              child: Text(
                                "Apartment images",
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image(
                            image: AssetImage("assets/sample/apartment1.jpg")),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                        "This is the first photo other users see",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14))
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {}, // TODO: Edit main photo
                                  icon: const Icon(Icons.edit),
                                  iconSize: 24,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Additional photos"),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 1.0,
                          childAspectRatio: 2.0),
                      padding: EdgeInsets.zero,
                      itemCount: 12,
                      itemBuilder: (BuildContext context, int index) {
                        return Image(
                            image: AssetImage("assets/sample/apartment2.jpg"));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
