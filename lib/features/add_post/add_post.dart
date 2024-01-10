import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/resources/services/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/util_methods.dart';
import 'package:provider/provider.dart';

import '../../utils/dimensions.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  late TextEditingController description;
  bool _isLoading = false;

  savePost(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    await FireStoreMethods().storePost(
        uid: uid,
        description: description.text.trim(),
        username: username,
        profileImage: profileImage,
        file: _file!,
        onFailure: () {
          setState(() {
            _isLoading = false;
          });
          context.showSnackBar("An error occurred");
        },
        onSuccess: () {
          setState(() {
          _isLoading = false;

          });
          context.showSnackBar("Posted");
          clearImage();
        });
  }

  clearImage(){
    setState(() {
      _file = null;
    });
  }

  _selectImage() async {
    final navigator = Navigator.of(context, rootNavigator: true);
    return showAdaptiveDialog(
        context: context,
        builder: (builder) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(Dimensions.dialogPadding),
                child: const Text("Take a photo"),
                onPressed: () async {
                  navigator.pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(Dimensions.dialogPadding),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  navigator.pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(Dimensions.dialogPadding),
                child: const Text("Cancel"),
                onPressed: () async {
                  navigator.pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    description = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    if (_file == null) {
      return Scaffold(
            body: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColours.primaryColor,
                ),
                icon: const Icon(Icons.upload),
                onPressed: _selectImage,
                label: const Text("Add a post"),
              ),
            ),
          );
    } else {
      return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(Icons.close),
              ),
              title: const Text("Post to"),
              actions: [
                TextButton(
                  onPressed: () {
                    savePost(user!.uid, user.username, user.photoUrl);
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: AppColours.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.appBarFontSize,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user!.photoUrl.isEmpty
                            ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                            : user.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: TextField(
                        controller: description,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          hintStyle: TextStyle(),
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),

              ],
            ),
        bottomSheet: _isLoading? const LinearProgressIndicator(color: AppColours.primaryColor,):null,
          );
    }
  }
}
