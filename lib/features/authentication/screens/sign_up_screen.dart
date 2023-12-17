import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/widgets/text_field.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.screenPadding,
          ),
          width: Dimensions.screenWidth,
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

                // theme: const SvgTheme(currentColor: AppColours.webBackgroundColor,),
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
                controller: _usernameController,
                hintText: "Enter your username",
                textInputType: TextInputType.text,
              ),
              CTextField(
                controller: _passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              CTextField(
                controller: _confirmPasswordController,
                hintText: "Confirm your password",
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              InkWell(
                child: Container(
                  width: Dimensions.screenWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.buttonPadding,
                  ),
                  decoration: ShapeDecoration(
                    color: AppColours.blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.textFieldRadius),
                    ),
                  ),
                  child: const Text("Sign Up"),
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
                      onPressed: () {},
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
