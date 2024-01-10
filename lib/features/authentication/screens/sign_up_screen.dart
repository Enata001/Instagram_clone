import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/services/auth_methods.dart';
import 'package:instagram_clone/resources/widgets/text_field.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/util_methods.dart';

import '../../../utils/navigation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _bioController;
  late TextEditingController _usernameController;
  Uint8List? file;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _bioController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List result = await pickImage(ImageSource.gallery);
    setState(() {
      file = result;
    });
  }

  void signUpUser() async {
    if (_usernameController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _passwordController.text.trim().isNotEmpty ||
        _bioController.text.trim().isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await AuthMethods().signUpUser(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          bio: _bioController.text.trim(),
          file: file,
          onSuccess: (){
            context.goNamed(Navigation.homeTab);

          },
          onFailure: (content) {
            context.showSnackBar(content);
          });
      setState(() {
        _isLoading = false;
      });
    } else {
      context.showSnackBar("Please fill all required fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:  EdgeInsets.symmetric(
            horizontal:  MediaQuery.sizeOf(context).width > Dimensions.webScreenSize
                ? MediaQuery.sizeOf(context).width * 0.3
                : Dimensions.screenPadding,
          ),
          width: Dimensions.screenSize,
          height: Dimensions.screenSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                ),
                SvgPicture.asset(
                  'assets/image/instagram.svg',
                  // theme: const SvgTheme(currentColor: AppColours.webBackgroundColor,),
                  color: AppColours.primaryColor,
                  height: Dimensions.logoHeight,
                ),
                const SizedBox(
                  height: Dimensions.logoDistance,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: Dimensions.logoHeight,
                      backgroundColor: Colors.grey,
                      backgroundImage: file == null ? null : MemoryImage(file!),
                      child: file == null
                          ? SvgPicture.asset(
                              'assets/image/avatar.svg',
                              height: Dimensions.logoDistance,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.logoDistance,
                ),
                CTextField(
                  controller: _usernameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text,
                ),
                CTextField(
                  controller: _emailController,
                  hintText: "Enter your e-mail",
                  textInputType: TextInputType.emailAddress,
                ),
                CTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPassword: true,
                ),
                CTextField(
                  controller: _bioController,
                  hintText: "Something about you",
                  textInputType: TextInputType.text,
                  isPassword: true,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColours.blueColor,
                        )
                      : Container(
                          width: Dimensions.screenSize,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.buttonPadding,
                          ),
                          decoration: ShapeDecoration(
                            color: AppColours.blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.textFieldRadius),
                            ),
                          ),
                          child: const Text("Sign Up"),
                        ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.contentPadding),
                      child: const Text(
                        "Already have an account?",
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.contentPadding,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.contentPadding),
                      child: TextButton(
                        onPressed: () {
                          context.pushNamed(Navigation.login);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold,color:AppColours.primaryColor ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: Dimensions.buttonPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
