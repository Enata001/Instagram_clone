import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/features/account/widgets/follow_button.dart';
import 'package:instagram_clone/resources/services/auth_methods.dart';
import 'package:instagram_clone/resources/services/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/navigation.dart';
import 'package:instagram_clone/utils/util_methods.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/provider.dart';

class Account extends StatefulWidget {
  final String uid;

  const Account({super.key, required this.uid});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    bool isUser = false;
    bool isFollowing = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Profile"),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.hasData) {
              isUser = user?.uid == snapshot.data!.data()?['uid'];
              isFollowing =
                  snapshot.data!.data()?['followers'].contains(user?.uid);
              // print(isUser);
              // print(isFollowing);

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.cardProfile),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: Dimensions.avatarRadius,
                              backgroundColor: AppColours.blueColor,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.data()?['photoUrl'] == ""
                                      ? context.photoUrl
                                      : snapshot.data!.data()?['photoUrl']),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      StreamBuilder<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .where('uid',
                                                  isEqualTo: snapshot.data!
                                                      .data()?['uid'])
                                              .snapshots(),
                                          builder: (context, snap) {
                                            if (snap.connectionState ==
                                                    ConnectionState.done ||
                                                snap.hasData) {
                                              var posts =
                                                  snap.data?.docs.length ?? 0;
                                              return buildStatColumn(
                                                  posts, "posts");
                                            }
                                            return const CircularProgressIndicator(
                                              color: AppColours.blueColor,
                                            );
                                          }),
                                      buildStatColumn(
                                          snapshot.data!
                                              .data()?['followers']
                                              .length,
                                          "followers"),
                                      buildStatColumn(
                                          snapshot.data!
                                              .data()?['following']
                                              .length,
                                          "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FollowButton(
                                        text: isUser
                                            ? "Sign Out"
                                            : isFollowing
                                                ? "Unfollow"
                                                : "Follow",
                                        backgroundColor: isUser
                                            ? AppColours.mobileBackgroundColor
                                            : isFollowing
                                                ? AppColours.primaryColor
                                                : AppColours.blueColor,
                                        borderColor: isUser
                                            ? Colors.grey
                                            : isFollowing
                                                ? Colors.grey
                                                : AppColours.blueColor,
                                        textColor: isUser
                                            ? AppColours.primaryColor
                                            : isFollowing
                                                ? Colors.black
                                                : AppColours.primaryColor,
                                        function: isUser
                                            ? () async {
                                                await AuthMethods().signOut(
                                                    onSuccess: () {
                                                  context.goNamed(
                                                      Navigation.login);
                                                }, onFailure: (result) {
                                                  context.showSnackBar(
                                                      "An error occurred");
                                                });
                                              }
                                            : isFollowing
                                                ? () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                            user!.uid,
                                                            widget.uid,
                                                            (_) => null);
                                                  }
                                                : () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                            user!.uid,
                                                            widget.uid,
                                                            (_) => null);
                                                  },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              top: Dimensions.buttonPadding),
                          child: Text(
                            snapshot.data!.data()?['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1, bottom: 5),
                          child: Text(
                            snapshot.data!.data()?['bio'],
                          ),
                        ),
                        const Divider(),
                        FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                            builder: (builder, snapshot) {
                              if (snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if ((snapshot.data! as dynamic).docs.length ==
                                    0) {
                                  return const Center(child: Text("No Posts"));
                                }
                                return GridView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        (snapshot.data! as dynamic).docs.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 3,
                                            mainAxisSpacing: 1.5,
                                            childAspectRatio: 1),
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['postUrl']);
                                    });
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColours.blueColor,
              ),
            );
          }),
    );
  }

  Column buildStatColumn(int number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(
            fontSize: Dimensions.profileFontSize,
          ),
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: Dimensions.profileFontLabel,
              color: AppColours.secondaryColor.withOpacity(0.5)),
        ),
      ],
    );
  }
}
