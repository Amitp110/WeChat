import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String userLoggedInFlag = "LOGGEDINFLAG";
  static String userName = "USERNAME";
  static String userEmail = "USEREMAIL";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInFlag, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String uName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userName, uName);
  }

  static Future<bool> saveUserEmailSF(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmail, email);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInFlag);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmail);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userName);
  }
}
