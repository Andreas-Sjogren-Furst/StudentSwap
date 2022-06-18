import "package:flutter/material.dart";

class chatsLine extends StatefulWidget {
  const chatsLine(
      {Key? key, required this.currentUserId, required this.counterUserId})
      : super(key: key);

  final String currentUserId;
  final String counterUserId;

  @override
  State<chatsLine> createState() => _chatsLineState();
}

class _chatsLineState extends State<chatsLine> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
