// add the library related to firebase authentication.
import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // create instance of FirebaseAuthentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // create instance of Firebase FireStore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // get the current user
  static User get user => auth.currentUser!;

  // for checking if user are exists or not
  static Future<bool> userExist() async {
    // check the user id in auth.currentUser!.uid
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for create new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey, I'm using Chatting app",
        name: user.displayName.toString(),
        createdAt: time,
        lastActive: time,
        id: user.uid,
        isOnline: false,
        pushToken: '',
        email: user.email.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }
}
