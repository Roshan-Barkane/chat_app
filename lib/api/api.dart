// add the library related to firebase authentication.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // create instance of FirebaseAuthentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // create instance of Firebase FireStore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}
