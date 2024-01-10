import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/navigation.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: AppColours.mobileBackgroundColor,
        ),
        routerConfig: AppRoute().router,
        // initialRoute: Navigation.entry,
        // onGenerateRoute: Navigation.onGenerateRoute,
      ),
    );
  }
}
