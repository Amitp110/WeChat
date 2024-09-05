import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/shared/sharedpref.dart';
import 'package:wechat/theme/colors.dart';
import 'package:wechat/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String localEmail;
  const ChatPage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.localEmail})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// Asrqw@1234we

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String userNameLocal = "";
  var userEmailLocal = "";

  bool isMessagesLoad = false;

  var messages;

  @override
  void initState() {
    getCurrentUser();
    getOldMessages();
    super.initState();
  }

  getOldMessages() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getChats()
        .then((snapshot) {
      var localMessage;

      List<Map<String, dynamic>> msg = [];

      localMessage = snapshot;

      for (int i = 0; i < localMessage.length; i++) {
        if ((localMessage[i]['msgBy'] == widget.localEmail &&
                localMessage[i]['msgTo'] == widget.userEmail) ||
            localMessage[i]['msgTo'] == widget.localEmail &&
                localMessage[i]['msgBy'] == widget.userEmail) {
          msg.add(localMessage[i]);
        }
      }

      for (int i = 0; i < msg.length; i++) {
        print("Date $i -->${msg[i]['time']}");
      }

      if (msg.length >= 2) {
        msg.sort((a, b) {
          return a['time'].compareTo(b['time']);
        });
      }

      messages = msg;

      isMessagesLoad = true;
      setState(() {});
    });
  }

  getCurrentUser() async {
    await SharedPref.getUserEmailFromSF().then((val) {
      if (val != null) {
        userEmailLocal = val;
      }
    });

    await SharedPref.getUserNameFromSF().then((val) {
      if (val != null) {
        userNameLocal = val;
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("Chat with ${widget.userName}"),
          backgroundColor: ColorTheme.primaryRed,
        ),
        body: Stack(
          children: <Widget>[
            // chat messages here
            isMessagesLoad
                ? chatMessages()
                : const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorTheme.primaryWhite,
                    ),
                  ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[500],
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: ColorTheme.primaryWhite),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(
                          color: ColorTheme.primaryWhite, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: ColorTheme.primaryRed,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        color: ColorTheme.primaryWhite,
                      )),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  chatMessages() {
    return messages.length > 0
        ? ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageTile(
                  message: messages[index]['message'],
                  sender: messages[index]['name'],
                  sentByMe: messages[index]['msgBy'] == userEmailLocal);
            },
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Center(
              child: Text(
                "chat now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.primaryRed,
                ),
              ),
            ));
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text.trim(),
        "msgTo": widget.userEmail,
        "msgBy": userEmailLocal,
        "time": DateTime.now().toString(),
        "name": userNameLocal,
      };

      DatabaseService().sendMessage(chatMessageMap);

      messages.add(chatMessageMap);

      setState(() {
        messageController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }
}
