import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/providers/auth.dart';
import 'package:tradelinkedai/core/providers/main_provider.dart';
import 'package:tradelinkedai/core/routing/routes.dart';
import 'package:tradelinkedai/core/theme/theme_light.dart';
import 'package:tradelinkedai/screen/auth/login/login.dart';
import 'package:tradelinkedai/screen/auth/signup/signup.dart';
import 'package:tradelinkedai/screen/chat/chat_screen.dart';
import 'package:tradelinkedai/screen/home/admin_home.dart';
import 'package:tradelinkedai/screen/home/home.dart';
import 'package:tradelinkedai/screen/splash/splash_screen.dart';
import 'package:tradelinkedai/screen/user/users_screen.dart';

GlobalKey<ScaffoldMessengerState>? rootScaffoldMessengerKey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..isUserLogedIn()),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeLight().theme,
        onGenerateRoute: Routers.generateRoute,
        home: Scaffold(
          body: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              switch (auth.loggedInStatus) {
                case Status.Authenticating:
                  return SplashPage();
                case Status.LoggedInHome:
                  return HomePage();
                case Status.LoggedInAdmin:
                  return AdminHomePage();
                case Status.UsersScreen:
                  return UserScreen();
                case Status.LoggedOut:
                  return LoginPage();
                case Status.Registered:
                  return SignupPage();
                case Status.Chat:
                  return ChatPage(userId: '', userName: '', chatName: '', conversationId: '', boolnewchat: false, chatnRoom: '', 
                  );
                default:
                  return LoginPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
