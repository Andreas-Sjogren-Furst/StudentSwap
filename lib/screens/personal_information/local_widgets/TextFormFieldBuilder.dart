import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../local_functions/writeData.dart';

class TextFormFieldBuilder extends StatelessWidget {
  final String labelText;
  final TextEditingController userInfo;
  final String fireBaseId;

  TextFormFieldBuilder(
      {required this.labelText,
      required this.fireBaseId,
      required this.userInfo});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: userInfo,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
      onFieldSubmitted: (String inputField) {
        writeData(fireBaseId, inputField);
      },
    );
  }
}
