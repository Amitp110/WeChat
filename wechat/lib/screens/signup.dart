// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wechat/screens/home.dart';
import 'package:wechat/screens/login.dart';
import 'package:wechat/services/auth_service.dart';
import 'package:wechat/shared/sharedpref.dart';
import 'package:wechat/theme/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  bool _passwordVisible = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ColorTheme.primaryBlack))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
                    const Text(
                      "Create your account now to chat and explore",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: Image.asset(
                        "assets/signup.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
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
                                labelText: "Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: ColorTheme.primaryRed,
                                )),
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Name cannot be empty";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
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
                            obscureText: _passwordVisible,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorTheme.primaryRed, width: 2),
                              ),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: ColorTheme.primaryRed,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: ColorTheme.primaryRed,
                              ),
                            ),
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
                        ],
                      ),
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
                          "SignUp",
                          style: TextStyle(
                              color: ColorTheme.primaryWhite, fontSize: 16),
                        ),
                        onPressed: () {
                          signup();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(
                          color: ColorTheme.primaryBlack, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Login now",
                            style: const TextStyle(
                                color: ColorTheme.primaryBlack,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to logic page

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (Route<dynamic> route) => false);
                              }),
                      ],
                    )),
                  ],
                ),
              ),
            ),
    );
  }

  void signup() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await SharedPref.saveUserLoggedInStatus(true);
          await SharedPref.saveUserEmailSF(email);
          await SharedPref.saveUserNameSF(fullName);

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
