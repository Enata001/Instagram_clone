import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/utils/colors.dart';

class MobileDashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MobileDashboardScreen({required this.navigationShell, super.key});

  void onTap(context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Padding(

        padding: const EdgeInsets.only(top: 20.0),
        child: CupertinoTabBar(
          backgroundColor: AppColours.mobileBackgroundColor,
          activeColor: AppColours.primaryColor,
          currentIndex: navigationShell.currentIndex,
          onTap: (int index) => onTap(context, index),
          items: const [
            BottomNavigationBarItem(

              icon: Icon(Icons.home),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
