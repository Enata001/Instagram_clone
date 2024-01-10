import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/navigation.dart';
import 'package:instagram_clone/utils/util_methods.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ConstrainedBox(
          constraints: const BoxConstraints(
              maxHeight: Dimensions.searchBarHeight,
              maxWidth: Dimensions.screenSize),
          child: SearchBar(
            controller: searchController,
            hintText: "Search for user",
            leading: const Icon(
              Icons.search,
              color: AppColours.primaryColor,
            ),
            trailing: [
              IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.clear,
                  color: AppColours.primaryColor,
                ),
              ),
            ],
            onChanged: (val) {
              setState(() {});
            },
          ),
        ),
      ),
      body: searchController.text.isNotEmpty
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text.trim(),
                  )
                  .where('username',
                      isLessThanOrEqualTo: '${searchController.text}\uf8ff')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColours.blueColor,
                    ),
                  );
                }
                if ((snapshot.data! as dynamic).docs.length == 0) {
                  return const Center(child: Text("No matching results"));
                }

                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (itemBuilder, index) {
                      return InkWell(
                        onTap: (){
                          GoRouter.of(context).pushNamed("account", extra: snapshot.data!.docs[index]['uid']);

                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                            ['photoUrl'] ==
                                        ""
                                    ? context.photoUrl
                                    : (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl']),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    });
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (builder, snapshot) {
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.hasData) {
                  return GridView.builder(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 3,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        // repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [
                          const QuiltedGridTile(2, 2),
                          const QuiltedGridTile(2, 1),
                          const QuiltedGridTile(2, 2),
                          const QuiltedGridTile(1, 1),
                        ],
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                            (snapshot.data! as dynamic).docs[index]['postUrl']);
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColours.blueColor,
                  ),
                );
              }),
    );
  }
}
