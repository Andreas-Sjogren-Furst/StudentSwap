import 'package:flutter/material.dart';
import "../screens/IndividualChatPage.dart";

class ChatLineModel {
  late String name;
  late String messageText;
  late String imageUrl;
  late String time;
  late String shaKey;
  late String currentUserName;

  ChatLineModel({
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
    required this.shaKey,
    required this.currentUserName,
  });

  ChatsLine getChatsLine() {
    return ChatsLine(
      name: name,
      messageText: messageText,
      imageUrl: imageUrl,
      time: time,
      shaKey: shaKey,
      currentUserName: currentUserName,
    );
  }
}

class ChatsLine extends StatefulWidget {
  // late bool isMessageRead;
  ChatsLine({
    Key? key,
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
    required this.shaKey,
    required this.currentUserName,
  }) : super(key: key);
  final String shaKey;
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
  final String currentUserName;

  @override
  _ChatsLineState createState() => _ChatsLineState();
}

class _ChatsLineState extends State<ChatsLine> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (IndividualChatpage(
                      shaKey: widget.shaKey,
                      counterUserName: widget.name,
                      currentUserName: widget.currentUserName,
                    ))));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
