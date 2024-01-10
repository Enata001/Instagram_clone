import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/services/storage_methods.dart';
import 'firestore_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    Uint8List? file,
    Function(String)? onFailure,
    Function? onSuccess,
  }) async {
    String result = "";
    String photoUrl = "";
    try {
      var credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (file == null) {
      } else {
        photoUrl = await StorageMethods()
            .uploadImage(childName: "profilePictures", file: file);
      }
      await FireStoreMethods()
          .storeUserInfo(credential, username, email, bio, photoUrl)
          .whenComplete(() {
        onSuccess?.call();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        {
          result = "The email is badly formatted";
        }
      } else {
        result = e.code;
      }
      onFailure?.call(result);
    }
  }

  Future loginUser({
    required String email,
    required String password,
    Function? onSuccess,
    Function(String)? onFailure,
  }) async {
    String result = "";
    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      onSuccess?.call();
    } on FirebaseAuthException catch (e) {
      result = e.code;
      onFailure?.call(result);
    }
  }

  Future signOut(
      {required VoidCallback onSuccess,
      required Function(String)? onFailure}) async {
    try {
      await _auth.signOut().whenComplete(() {

        onSuccess.call();
      });
    } on FirebaseAuthException catch (e) {
      onFailure?.call(e.code);
    }
  }
}
