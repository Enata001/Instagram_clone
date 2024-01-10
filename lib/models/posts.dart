import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String description;
  final String username;
  final String postId;
  final DateTime datePublished;
  final List likes;
  final String profileImage;
  final String postUrl;

  Post({
    required this.uid,
    required this.description,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.profileImage,
    required this.postUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'description': description,
      'username': username,
      'postId': postId,
      'datePublished': datePublished,
      'likes': likes,
      'profileImage': profileImage,
      'postUrl': postUrl,
    };
  }

  factory Post.fromJson(Map<String, dynamic> map) {
    return Post(
      uid: map['uid'] as String,
      description: map['description'],
      username: map['username'],
      postId: map['postId'],
      datePublished: map['datePublished'],
      likes: map['likes'],
      profileImage: map['profileImage'],
      postUrl: map['postUrl'],
    );
  }

  factory Post.fromSnap(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;
    return Post(
      uid: map['uid'] as String,
      description: map['description'],
      username: map['username'],
      postId: map['postId'],
      datePublished: map['datePublished'],
      likes: map['likes'],
      profileImage: map['profileImage'],
      postUrl: map['postUrl'],
    );
  }
}
