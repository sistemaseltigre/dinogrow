import 'package:dinogrow/ui/widgets/GameCard/game_card.dart';
import 'package:flutter/material.dart';

import '../../ui/widgets/widgets.dart';

class MiniGamesScreen extends StatefulWidget {
  const MiniGamesScreen({Key? key}) : super(key: key);

  @override
  State<MiniGamesScreen> createState() => _MiniGamesPageState();
}

class _MiniGamesPageState extends State<MiniGamesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ui/config_jungle_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Padding(
              padding: EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  GameCardWidget(
                    text: 'UP',
                    route: "/mini_games/up",
                  ),
                  GameCardWidget(text: 'COMING SOON'),
                  GameCardWidget(text: 'COMING SOON'),
                ],
              )),
        ),
      ),
    );
  }
}
