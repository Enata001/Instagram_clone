import 'package:flutter/material.dart';
import 'package:instagram_clone/features/home/home.dart';
import '../features/responsive/mobile_screen.dart';
import '../features/responsive/web_screen.dart';
import '../utils/colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: AppColours.mobileBackgroundColor,
      ),
      home: const ResponsiveLayout(MobileScreen(),WebScreen()),
    );
  }
}
