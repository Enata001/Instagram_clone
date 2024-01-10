import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/models/posts.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> storeUserInfo(UserCredential credential, String username,
      String email, String bio, String photoUrl) async {
    UserModel data = UserModel(
      uid: credential.user!.uid,
      email: email,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
      followers: [],
      following: [],
    );

    await _store
        .collection('users')
        .doc(credential.user?.uid)
        .set(data.toJson());
  }

  Future<UserModel> getUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var snapshot = await _store.collection('users').doc(currentUser?.uid).get();
    return UserModel.fromSnap(snapshot);
  }

  Future<void> storePost(
      {required String uid,
      required String description,
      required String username,
      required String profileImage,
      required Uint8List file,
      VoidCallback? onFailure,
      Function? onSuccess}) async {
    try {
      var postUrl = await StorageMethods()
          .uploadImage(childName: "posts", file: file, isPost: true);
      var postId = const Uuid().v1();
      var post = Post(
        uid: uid,
        description: description,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        profileImage: profileImage,
        postUrl: postUrl,
        likes: [],
      );

      await _store.collection("posts").doc(postId).set(post.toJson());
      onSuccess?.call();
    } on Exception {
      onFailure?.call();
    }
  }

  Future<bool> likePost(String postId, String uid, List likes) async {
    try {
      bool result;
      if (likes.contains(uid)) {
        await _store.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
        result = false;
      } else {
        await _store.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
        result = true;
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future postComment({
    required String postId,
    required String uid,
    required String username,
    required String profilePic,
    required String comment,
    required Function onSuccess,
    Function(String)? onFailure,
  }) async {
    try{
      String commentId = const Uuid().v1();
      await _store.collection('posts').doc(postId).collection("comments").doc(commentId).set(
          {
            'profilePic': profilePic,
            'username': username,
            'uid':uid,
            'comment':comment,
            'postId': postId,
            'commentId' : commentId,
            'datePublished': DateTime.now(),
          });
      onSuccess.call();
      
    }catch(e){
      onFailure?.call(e.toString());
    }
  }

  Future<void> deletePost({ required String postId, Function(String?)? onFailure}) async{
    try{
      await _store.collection('posts').doc(postId).delete();
    }catch (e){
      onFailure?.call(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId, Function(String?)? onFailure)async{
    try{
      var snap = await _store.collection('users').doc(uid).get();
      List following = snap.data()!['following'];
      if(following.contains(followId)){
        await _store.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
        await _store.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      }else{
        await _store.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _store.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    }catch(e){
    onFailure?.call(e.toString());

    }
  }
}
