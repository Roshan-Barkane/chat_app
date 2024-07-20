// add the library related to firebase authentication.
import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // create instance of FirebaseAuthentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // create instance of Firebase FireStore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // create instance of Firebase Storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static late ChatUser me;
  // get the current user
  static User get user => auth.currentUser!;

  // for checking if user are exists or not
  static Future<bool> userExist() async {
    // check the user id in auth.currentUser!.uid
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    // check the user id in auth.currentUser!.uid
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        debugPrint("User Date : ${user.data()}");
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
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

  // get the all present user in firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    // check the user id in auth.currentUser!.uid
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // updata profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    // get the extension of file
    final ext = file.path.split('.').last;
    debugPrint("Extansion : $ext");
    // create the file in firebase stored
    final ref = storage.ref().child("Profile_Picture/${user.uid}.$ext");
    // put the file local to server
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // show the massage we know data are transferred done !
      debugPrint("Data Transferred : ${p0.bytesTransferred / 100} kb");
    });
    // get the url on the server
    me.image = await ref.getDownloadURL();
    // update the image only
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  /* ==================== Chat Related APIs ======================= */

  // get the all message of specific Convergation in firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore.collection("massages").snapshots();
  }
}
