import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void onTap(context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/image/instagram.svg',
          color: AppColours.primaryColor,
          height: Dimensions.titleHeight,
        ),
        actions: [
          SizedBox(
            width: 350,
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorColor: Colors.transparent,

              indicatorShape: LinearBorder.bottom(
                  side: const BorderSide(color: Colors.white)),
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (int index) => onTap(context, index),
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.grey,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                  ),
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.grey,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  icon: Icon(
                    Icons.person_outlined,
                    color: Colors.grey,
                  ),
                  label: '',
                ),
              ],
            ),
          )
        ],
      ),
      body: navigationShell,
    );
  }
}
