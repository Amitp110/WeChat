// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wechat/screens/home.dart';
import 'package:wechat/screens/signup.dart';
import 'package:wechat/services/auth_service.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/shared/sharedpref.dart';
import 'package:wechat/theme/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ColorTheme.primaryBlack),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "WeChat",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: ColorTheme.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Login now for chatting!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        Image.asset("assets/login.png"),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                  color: ColorTheme.primaryBlack,
                                  fontWeight: FontWeight.w300),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: ColorTheme.primaryRed,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                  color: ColorTheme.primaryBlack,
                                  fontWeight: FontWeight.w300),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: ColorTheme.primaryRed,
                              )),
                          validator: (value) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
                            if (value!.isEmpty) {
                              return "Please enter password ";
                            } else if (!regex.hasMatch(value)) {
                              return "Please enter alpha numeric, special character and min 6 char password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorTheme.primaryRed,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: ColorTheme.primaryWhite, fontSize: 16),
                            ),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: ColorTheme.primaryBlack, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                    color: ColorTheme.primaryBlack,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // navigate to signup page
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp()),
                                        (Route<dynamic> route) => false);
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          // saving the values to our shared preferences
          await SharedPref.saveUserLoggedInStatus(true);
          await SharedPref.saveUserEmailSF(email);
          await SharedPref.saveUserNameSF(snapshot.docs[0]['fullName']);

          // navigation to home screen
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Home()),
              (Route<dynamic> route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
            backgroundColor: ColorTheme.primaryRed,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: "OK",
              textColor: ColorTheme.primaryWhite,
              onPressed: () {},
            ),
          ));

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
