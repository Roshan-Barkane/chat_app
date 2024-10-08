// add the library related to firebase authentication.
import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/massage.dart';
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

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection("users")
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online and last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection("users").doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
  /* ==================== Chat Related APIs ======================= */

  // chats (collection) --> conversation_id(doc) --> messages(collection) --> messages(doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // get the all message of specific Conversation in firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection("chats/${getConversationID(user.id)}/massages")
        .orderBy('send', descending: true)
        .snapshots();
  }

  // for sending massage
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // message to send
    final Massage massage = Massage(
        toid: user.uid,
        msg: msg,
        read: '',
        type: type,
        send: time,
        fromid: user.uid);
    final ref = firestore
        .collection("chats/${getConversationID(chatUser.id)}/massages");
    // we make a doc id are time
    await ref.doc(time).set(massage.toJson());
  }

  // update read statues massage
  static Future<void> updateMessageReadStatus(Massage massage) async {
    firestore
        .collection("chats/${getConversationID(massage.fromid)}/massages")
        .doc(massage.send)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        .collection("chats/${getConversationID(user.id)}/massages")
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }

  // send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    // get the extension of file
    final ext = file.path.split('.').last;
    //  debugPrint("Extansion : $ext");
    // create the file in firebase stored
    final ref = storage.ref().child(
        "Images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    // put the file local to server
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // show the massage we know data are transferred done !
      debugPrint("Data Transferred : ${p0.bytesTransferred / 100} kb");
    });
    // get the url on the server
    final imageUrl = await ref.getDownloadURL();
    // update the image only
    sendMessage(chatUser, imageUrl, Type.image);
  }
}
