import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/features/home/widgets/like_animation.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/resources/services/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/util_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/navigation.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getLikes();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    double width =  MediaQuery.sizeOf(context).width;

    return Container(
      color: AppColours.mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.postCardPadding),
      margin:  EdgeInsets.symmetric(horizontal:  width > Dimensions.webScreenSize  ? width * 0.25 : 1 ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: Dimensions.cardProfile,
                  backgroundImage: NetworkImage(
                      widget.snap['profileImage'] == ""
                          ? context.photoUrl
                          : widget.snap['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: widget.snap["username"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColours.primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (itemBuilder) {
                    return [
                      PopupMenuItem(
                        enabled: widget.snap['uid'] == user!.uid ? true : false,
                        onTap: ()async{
                          FireStoreMethods().deletePost(postId: widget.snap['postId']);
                        },
                        child: const Text("Delete Post"),

                      ),
                      const PopupMenuItem(
                        child: Text("Cancel"),

                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                  widget.snap["postId"], user!.uid, widget.snap["likes"]);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.center,
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
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          size: Dimensions.likeSize,
                          color: AppColours.primaryColor,
                        )),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user?.uid),
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                        widget.snap["postId"], user!.uid, widget.snap["likes"]);
                    setState(() {});
                  },
                  icon: widget.snap["likes"].contains(user?.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.pushNamed(Navigation.comments, extra: widget.snap);
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border_outlined),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimensions.cardProfile),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.snap["likes"].length} likes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: Dimensions.screenSize,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: AppColours.primaryColor),
                        children: [
                          TextSpan(
                            text: "${widget.snap["username"]}  ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: widget.snap["description"] == ""
                                ? "No description"
                                : widget.snap["description"],
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.pushNamed(Navigation.comments, extra: widget.snap);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.snap["postId"])
                            .collection('comments')
                            .snapshots(),
                        builder: (context, snapshot) {
                          var result = snapshot.data?.docs.length;
                          return Text(
                            "View all ${result ?? 0 } comments",
                            style: const TextStyle(
                                fontSize: Dimensions.cardProfile,
                                color: AppColours.secondaryColor),
                          );
                        }),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(
                    (widget.snap["datePublished"].toDate()),
                  ),
                  style: const TextStyle(
                    fontSize: Dimensions.cardProfile,
                    color: AppColours.secondaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
