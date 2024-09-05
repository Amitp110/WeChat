import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wechat/screens/login.dart';
import 'package:wechat/services/auth_service.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/shared/sharedpref.dart';
import 'package:wechat/theme/colors.dart';
import 'package:wechat/widgets/user_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "";
  String email = "";

  bool isDataLoad = false;

  AuthService authService = AuthService();
  var users;

  @override
  void initState() {
    super.initState();

    getAllUsers();
  }

  void getAllUsers() async {
    await SharedPref.getUserEmailFromSF().then((val) {
      if (val != null) {
        email = val;
      }
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUsers()
        .then((snapshot) {
      setState(() {
        users = snapshot;

        int index = 0;

        for (int i = 0; i < users.length; i++) {
          if (users[i]['email'] == email) {
            index = i;
            break;
          }
        }
        users.removeAt(index);

        isDataLoad = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await authService.signOut();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(
                  Icons.logout,
                ))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: ColorTheme.primaryRed,
          title: const Text(
            "Home",
            style: TextStyle(
                color: ColorTheme.primaryWhite,
                fontWeight: FontWeight.bold,
                fontSize: 27),
          ),
        ),
        body: isDataLoad
            ? userList()
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: ColorTheme.primaryWhite,
                ),
              ),
      ),
    );
  }

  userList() {
    return users.length > 0
        ? ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserTile(
                userId: users[index]['uid'],
                userName: users[index]['fullName'],
                userEmail: users[index]['email'],
                localEmail: email,
              );
            },
          )
        : noUserWidget();
  }

  noUserWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: const Center(
          child: Text(
            "No one here to talk.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorTheme.primaryRed,
            ),
          ),
        ));
  }
}
