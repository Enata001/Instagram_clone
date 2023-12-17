import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(this.mobileScreenLayout, this.webScreenLayout, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if (constraints.maxWidth> Dimensions.webScreenSize){
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
