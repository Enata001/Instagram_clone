import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/comments/widgets/comment_card.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/resources/services/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/util_methods.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final Map<String, dynamic> snap;

  const CommentsPage({super.key, required this.snap});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late TextEditingController commentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController;
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.35,
            width: Dimensions.screenSize,
            child: Image.network(
              widget.snap["postUrl"],
              filterQuality: FilterQuality.none,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments').orderBy('datePublished')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,

                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return CommentCard(
                        comment: data?['comment'],
                        photoUrl: data?['profilePic'],
                        datePublished: data?['datePublished'],
                        username: data?['username'],
                      );
                    });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          padding: const EdgeInsets.only(
              left: Dimensions.commentPaddingLeft,
              right: Dimensions.commentPaddingRight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    user!.photoUrl == "" ? context.photoUrl : user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Dimensions.commentPaddingLeft,
                      right: Dimensions.commentPaddingRight),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Comment as ${user.username}..."),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  String comment = commentController.text.trim();
                  commentController.clear();
                  await FireStoreMethods().postComment(
                      postId: widget.snap['postId'],
                      uid: user.uid,
                      username: user.username,
                      profilePic: user.photoUrl == ""
                          ? context.photoUrl
                          : user.photoUrl,
                      comment: comment,
                      onSuccess: () {

                      });
                },
                icon: const Icon(
                  Icons.send,
                  color: AppColours.blueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
