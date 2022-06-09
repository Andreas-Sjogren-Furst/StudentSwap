import "package:flutter/material.dart";

class FailScreen extends StatelessWidget {
//  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text('Oops something went wrong, please go back'),
    );
  }
}
