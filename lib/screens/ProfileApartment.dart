import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileApartment extends StatefulWidget {
  static const routeName = "/profile-apartment";

  const ProfileApartment({Key? key}) : super(key: key);

  @override
  State<ProfileApartment> createState() => _ProfileApartmentState();
}

class _ProfileApartmentState extends State<ProfileApartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apartment Photos"),
      ),
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
                children: const [
                  TopPhoto(),
                  SizedBox(height: 8.0),
                  PhotoGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Grid of photos at the bottom
class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
              itemCount: 24,
              itemBuilder: (BuildContext context, int index) {
                return index % 2 == 0
                    ? InkWell(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => const ImageDialog(
                                  ai: AssetImage(
                                      "assets/sample/apartment1.jpg")));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: const Image(
                                image:
                                    AssetImage("assets/sample/apartment1.jpg"),
                                fit: BoxFit.cover)),
                      )
                    : InkWell(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => const ImageDialog(
                                  ai: AssetImage(
                                      "assets/sample/apartment2.jpg")));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: const Image(
                                image:
                                    AssetImage("assets/sample/apartment2.jpg"),
                                fit: BoxFit.cover)),
                      );
              })
        ],
      ),
    );
  }
}

// Main photo at the top
class TopPhoto extends StatelessWidget {
  const TopPhoto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) => const ImageDialog(
                    ai: AssetImage("assets/sample/apartment1.jpg")));
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child:
                const Image(image: AssetImage("assets/sample/apartment1.jpg")),
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
                    onPressed: () {}, // TODO: Edit main photo
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

// Dialog to show photos when clicked
class ImageDialog extends StatelessWidget {
  const ImageDialog({Key? key, required this.ai}) : super(key: key);

  final AssetImage ai;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Image(
        image: ai,
        fit: BoxFit.contain,
      ),
    );
  }
}
