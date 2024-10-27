import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/providers/main_provider.dart';
import 'package:tradelinkedai/core/routing/ErrorRoute.dart';
import 'package:tradelinkedai/screen/auth/login/login.dart';
import 'package:tradelinkedai/screen/auth/signup/signup.dart';
import 'package:tradelinkedai/screen/chat/chat_screen.dart';


class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    print("these are arguments ${settings.arguments}");
    print("these are arguments ${settings.name}");
    switch (settings.name) {
      case '/signin':
        return PageTransition(
            child: LoginPage(), type: PageTransitionType.rightToLeft);

      case '/register':
        return PageTransition(
            child: SignupPage(), type: PageTransitionType.rightToLeft);

      // case '/home':
      //   return PageTransition(
      //       child: MainPage(), type: PageTransitionType.rightToLeft);

      // case '/chatScreen':
      //   {
      //     Map<String, dynamic>? params = args as Map<String, dynamic>?;
      //     return PageTransition(
      //         child: ListenableProvider<MainProvider>.value(
      //           value: params!["groupListProvider"],
      //           child: ChatPage(),
      //         ),
      //         type: PageTransitionType.rightToLeft);
      //   }

      default:
        return MaterialPageRoute(
            builder: (_) => ErrorRoute(routename: settings.name));
    }
  }
}
