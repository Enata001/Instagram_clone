import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(this.mobileScreenLayout, this.webScreenLayout, {super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    await user.refreshUser();

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if (constraints.maxWidth> Dimensions.webScreenSize){
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
