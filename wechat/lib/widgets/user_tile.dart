import 'package:flutter/material.dart';
import 'package:wechat/screens/chat_page.dart';
import 'package:wechat/theme/colors.dart';

class UserTile extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String localEmail;
  const UserTile(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.localEmail})
      : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              userId: widget.userId,
              userName: widget.userName,
              userEmail: widget.userEmail,
              localEmail: widget.localEmail,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: ColorTheme.primaryRed,
            child: Text(
              widget.userName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: ColorTheme.primaryWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 25),
            ),
          ),
          title: Text(
            widget.userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
