import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/features/account/screens/account.dart';
import 'package:instagram_clone/features/authentication/screens/login_screen.dart';
import 'package:instagram_clone/features/comments/screens/comments_page.dart';
import 'package:instagram_clone/features/favourites/favourites.dart';
import 'package:instagram_clone/features/responsive/screens/dashboard_screen.dart';
import 'package:instagram_clone/features/home/screens/home_page.dart';
import 'package:instagram_clone/features/search/screens/search.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:provider/provider.dart';
import '../features/add_post/add_post.dart';
import '../features/authentication/screens/sign_up_screen.dart';

class Navigation {
  Navigation._();

  static const home = "home";
  static const login = "login";
  static const signUp = "sign_up";
  static const homeTab = "home_tab";
  static const search = "search";
  static const add = "add";
  static const favourites = "favourites";
  static const account = "account";
  static const comments = "comments";

// static Route<dynamic> onGenerateRoute(RouteSettings route) {
//   // final args = route.arguments;
//
//   switch (route.name) {
//     case entry:
//       return pageRoute(const ResponsiveLayout(MobileScreen(), WebScreen()));
//     default:
//       return _pageNotFound();
//   }
// }

// static pageRoute(Widget page) {
//   return MaterialPageRoute(builder: (builder) => page);
// }

// static Route<dynamic> _pageNotFound() {
//   return MaterialPageRoute(builder: (builder) {
//     return const Scaffold(
//       body: Center(
//         child: Text("Page does not Exist"),
//       ),
//     );
//   });
// }
}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class AppRoute {
  final GoRouter router = GoRouter(
      navigatorKey: navKey,
      initialLocation: "/login",

      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => DashboardScreen(
            navigationShell: navigationShell,
          ),
          branches: [
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: Navigation.homeTab,
                  path: "/home_tab",
                  builder: (context, state) => const HomePage(),
                  redirect: (context, state) {
                    if (FirebaseAuth.instance.currentUser == null) {
                      return "/login";
                    }
                    return null;
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: Navigation.search,
                  path: "/search",
                  builder: (context, state) => const Search(),
                  redirect: (context, state) {
                    if (FirebaseAuth.instance.currentUser == null) {
                      return "/login";
                    }
                    return null;
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: Navigation.add,
                  path: "/add",
                  builder: (context, state) => const AddPost(),
                  redirect: (context, state) {
                    if (FirebaseAuth.instance.currentUser == null) {
                      return "/login";
                    }
                    return null;
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: Navigation.favourites,
                  path: "/favourites",
                  builder: (context, state) => const Favourites(),
                  redirect: (context, state) {
                    if (FirebaseAuth.instance.currentUser == null) {
                      return "/login";
                    }
                    return null;
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: Navigation.account,
                  path: "/account",
                  builder: (context, state) {
                    var user = Provider.of<UserProvider>(context).getUser;
                    return Account(uid: (state.extra as String?)?? user!.uid );
                  },
                  redirect: (context, state) {
                    if (FirebaseAuth.instance.currentUser == null) {
                      return "/login";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: Navigation.login,
          path: "/login",
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: LoginScreen(),
            );
          },
          redirect: (context, state) {

            if (FirebaseAuth.instance.currentUser != null) {
              return "/home_tab";
            }
            return null;
          },
        ),
        GoRoute(
            name: Navigation.signUp,
            path: "/sign_up",
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: SignUpScreen(),
              );
            }),
        GoRoute(
            name: Navigation.comments,
            path: "/comments",
            pageBuilder: (context, state) {
              return MaterialPage(
                child: CommentsPage(snap: state.extra as Map<String, dynamic>),
              );
            }),
      ],
      errorPageBuilder: (context, state) => const MaterialPage(
            child: ErrorPage(),
          ));
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Page does not Exist"),
      ),
    );
  }
}
