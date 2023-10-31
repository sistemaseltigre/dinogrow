import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dinogrow/pages/generate_phrase.dart';
import 'package:dinogrow/pages/home.dart';
import 'package:dinogrow/pages/input_phrase.dart';
import 'package:dinogrow/pages/login.dart';
import 'package:dinogrow/pages/setup_account.dart';
import 'package:dinogrow/pages/setup_password.dart';
import 'package:dinogrow/pages/mini-games/mini_games.dart';
import 'package:dinogrow/pages/mini-games/up/up.dart';
import 'package:dinogrow/pages/mini-games/up/down.dart';
import 'package:dinogrow/pages/mini-games/coming_soon.dart';
import 'package:dinogrow/pages/profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

final GoRouter _router = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginScreen();
      }),
  GoRoute(
      path: '/setup',
      builder: (context, state) {
        return const SetUpScreen();
      }),
  GoRoute(
      path: '/inputPhrase',
      builder: (context, state) {
        return const InputPhraseScreen();
      }),
  GoRoute(
      path: '/generatePhrase',
      builder: (context, state) {
        return const GeneratePhraseScreen();
      }),
  GoRoute(
      path: '/passwordSetup/:mnemonic',
      builder: (context, state) {
        return SetupPasswordScreen(mnemonic: state.pathParameters["mnemonic"]);
      }),
  GoRoute(
      path: '/home',
      builder: (context, state) {
        return const HomeScreen();
      }),
  GoRoute(
      path: '/mini_games',
      builder: (context, state) {
        return const MiniGamesScreen();
      }),
  GoRoute(
      path: '/mini_games/up',
      builder: (context, state) {
        return GameWidgetUp(game: UpGame());
      }),
  GoRoute(
      path: '/mini_games/down',
      builder: (context, state) {
        return const GameWidgetDown();
      }),
  GoRoute(
      path: '/mini_games/comming_soon',
      builder: (context, state) {
        return const ComingSoonScreen();
      }),
  GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfileScreen();
      }),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[500],
        )),
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[850],
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
