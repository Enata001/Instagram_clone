import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  UserModel(
      {required this.uid,
      required this.email,
      required this.username,
      required this.bio,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "bio": bio,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following
      };

  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
        bio: map['bio'] as String,
        photoUrl: map['photoUrl'] as String,
        followers: map['followers'] as List,
        following: map['following'] as List,
      );

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var map = snap.data() as Map<String, dynamic>;
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        username: map['username'],
        bio: map['bio'] as String,
        photoUrl: map['photoUrl'],
        followers: map['followers'],
        following: map['following'],
      );
  }
}
