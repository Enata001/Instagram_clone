import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/resources/services/auth_methods.dart';
import 'package:instagram_clone/resources/widgets/text_field.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/util_methods.dart';

import '../../../utils/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (_emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await AuthMethods().loginUser(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          onSuccess: () {
            context.goNamed(Navigation.homeTab);
          },
          onFailure: (result) {
            context.showSnackBar(result);
          });
      setState(() {
        _isLoading = false;
      });
    } else {
      context.showSnackBar("Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal:
                MediaQuery.sizeOf(context).width > Dimensions.webScreenSize
                    ? MediaQuery.sizeOf(context).width * 0.3
                    : Dimensions.screenPadding,
          ),
          width: Dimensions.screenSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/image/instagram.svg',
                color: AppColours.primaryColor,
                height: Dimensions.logoHeight,
              ),
              const SizedBox(
                height: Dimensions.logoHeight,
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
              InkWell(
                onTap: login,
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
                              Dimensions.textFieldRadius,
                            ),
                          ),
                        ),
                        child: const Text("Log In"),
                      ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.contentPadding),
                    child: const Text(
                      "Don't have an account?",
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
                        context.pushNamed(Navigation.signUp);
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColours.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.buttonPadding),
            ],
          ),
        ),
      ),
    );
  }
}
