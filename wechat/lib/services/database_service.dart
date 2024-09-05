import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final db = FirebaseFirestore.instance;

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // reference for our collections
  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection("messages");

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // getting the chats
  getChats() async {
    QuerySnapshot querySnapshot = await messageCollection.get();

    dynamic allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  // get users
  getUsers() async {
    QuerySnapshot querySnapshot = await userCollection.get();

    dynamic allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  // send message
  sendMessage(Map<String, dynamic> chatMessageData) async {
    // store msg in firestore
    return await messageCollection.doc(uid).set({
      "message": chatMessageData['message'],
      "msgTo": chatMessageData['msgTo'],
      "msgBy": chatMessageData['msgBy'],
      "time": chatMessageData['time'],
      "name": chatMessageData['name'],
    });
  }
}
