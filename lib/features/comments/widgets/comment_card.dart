import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/util_methods.dart';
import 'package:intl/intl.dart';

import '../../../utils/dimensions.dart';

class CommentCard extends StatefulWidget {
  final String photoUrl;
  final String username;
  final String comment;
  final Timestamp datePublished;

  const CommentCard(
      {super.key,
      required this.photoUrl,
      required this.username,
      required this.comment,
      required this.datePublished});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.commentCardHeight,
        horizontal: Dimensions.commentCardWidth,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                widget.photoUrl == "" ? context.photoUrl : widget.photoUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: Dimensions.commentCardWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.username} ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColours.primaryColor),
                        ),
                        TextSpan(
                            text: widget.comment,
                            style: const TextStyle(
                                color: AppColours.primaryColor)),
                      ],
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(
                      top: Dimensions.commentPadding,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(widget.datePublished.toDate()),
                      style: const TextStyle(
                        fontSize: Dimensions.commentFontSize,
                        color: AppColours.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite_border_outlined),
          )
          // Container(padding: EdgeInsets.all(8),child: Icon(Icons.favorite_border_outlined,),),
        ],
      ),
    );
  }
}
