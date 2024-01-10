import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/features/home/widgets/post_card.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../../../utils/dimensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.sizeOf(context).width >Dimensions.webScreenSize?null:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/image/instagram.svg',
          color: AppColours.primaryColor,
          height: Dimensions.titleHeight,
        ),

      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy("datePublished", descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColours.blueColor,
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ));
          },
        ),
      ),
    );
  }
}
