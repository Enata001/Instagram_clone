import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layout_screen.dart';
import '../../home/screens/mobile_dashboard_screen.dart';
import 'web_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        MobileDashboardScreen(
          navigationShell: navigationShell,
        ),
        WebScreen(
          navigationShell: navigationShell,
        ));
  }
}
