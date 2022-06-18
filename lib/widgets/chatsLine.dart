import 'package:flutter/material.dart';



class ChatsLine extends StatefulWidget {
  late String name;
  late String messageText;
  late String imageUrl;
  late String time;
  // late bool isMessageRead;
  ChatsLine({
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
  });

  getChatsLine {
    return ChatsLine()
  }
  @override
  _ChatsLineState createState() => _ChatsLineState();
}

class _ChatsLineState extends State<ChatsLine> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }
}
