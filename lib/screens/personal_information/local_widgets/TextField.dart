import 'package:flutter/material.dart';
import '../local_functions/writeData.dart';

class TextFieldBuilder extends StatelessWidget {
  final String labelText;
  final TextEditingController userInfo;
  // ignore: use_key_in_widget_constructors
  const TextFieldBuilder({required this.labelText, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: userInfo,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
