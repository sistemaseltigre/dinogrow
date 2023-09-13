import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MiniGamesScreen extends StatefulWidget {
  const MiniGamesScreen({Key? key}) : super(key: key);

  @override
  State<MiniGamesScreen> createState() => _MiniGamesPageState();
}

class _MiniGamesPageState extends State<MiniGamesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Games'),  
      ),
      body: Center(
        child:Column(
        children: [
          TextButton(
                      child: const Text('UP GAME'),
                      onPressed: () {
                        GoRouter.of(context).go("/mini_games/up");
                      },
                    ),
        ]
        ),
      )
    );
  }
}