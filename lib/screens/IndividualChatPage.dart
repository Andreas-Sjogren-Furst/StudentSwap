import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "../models/ChatMessageModel.dart";

class IndividualChatpage extends StatefulWidget {
  const IndividualChatpage({
    Key? key,
    required this.shaKey,
    required this.counterUserName,
    required this.currentUserName,
  }) : super(key: key);
  final String shaKey;
  final String counterUserName;
  final String currentUserName;

  @override
  State<IndividualChatpage> createState() => _IndividualChatpageState();
}

class _IndividualChatpageState extends State<IndividualChatpage> {
  late String _shaKey;
  late String _currentUserName;
  late String _counterUserName;
  late ScrollController _scrollController;
  final myController = TextEditingController();
  @override
  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    myController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentUserName = widget.currentUserName;
    _shaKey = widget.shaKey;
    _counterUserName = widget.counterUserName;
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "<https://randomuser.me/api/portraits/men/5.jpg>"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _counterUserName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Text(widget.shaKey),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.shaKey)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SpinKitSquareCircle(
                    color: Colors.pink,
                    size: 80,
                  ),
                    
                    
                    
                    
                    
                    
                    
                  );
                }

                List<ChatMessage> messages = [];
                Object? chatDocument = snapshot.data!.data();
                chatDocument = chatDocument as Map<dynamic, dynamic>;
                List<dynamic> userChatMaps = chatDocument["Messages"];
                print(userChatMaps);

                userChatMaps.forEach((chatMap) {
                  chatMap.forEach((key, value) {
                    messages.add(
                        ChatMessage(messageType: key, messageContent: value));
                  });
                });

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        reverse: false,
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment: (messages[index].messageType ==
                                      _counterUserName // sortere besked hhv. venstre eller højre.
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (messages[index].messageType ==
                                          _counterUserName // giver beskeder farver.
                                      ? Colors.grey.shade200
                                      : Colors.blue[200]),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  messages[index].messageContent,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Map<dynamic, dynamic> chatMessage = {
                        _currentUserName: myController.text,
                      };
                      FirebaseFirestore.instance
                          .collection("chats")
                          .doc(_shaKey)
                          .update({
                        "Messages": FieldValue.arrayUnion([chatMessage]),
                      });
                      print(myController.text);
                      myController.clear();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
