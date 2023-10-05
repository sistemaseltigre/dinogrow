import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../ui/widgets/widgets.dart';

class MydinogrowScreen extends StatefulWidget {
  const MydinogrowScreen({super.key});

  @override
  State<MydinogrowScreen> createState() => _MydinogrowScreenState();
}

class _MydinogrowScreenState extends State<MydinogrowScreen> {
  final storage = const FlutterSecureStorage();
  final filters = [
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    )
  ];

  List<Widget> mintContent(_onClaim) => [
        const IntroLogoWidget(),
        const SizedBox(height: 30),
        IntroButtonWidget(
          text: 'Claim your Dino',
          onPressed: _onClaim,
        ),
        const SizedBox(height: 30),
        Container(
          color: Colors.orange[700],
          padding: const EdgeInsets.all(8),
          child: const Text(
            'Wait ... you must to have a Dino to start play our games, so "Claim your Dino" is our last step to auto-generate your first NFT free!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
      ];

  List<Widget> myDinosContent(returnImageColorFc) => [
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 12,
            itemBuilder: (context, index) {
              // final item = items[index];

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: returnImageColorFc(index),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        const GameCardWidget(
          text: 'Mini Dino',
          route: "/mini_games/up",
        ),
        const SizedBox(height: 30),
        const TextBoxWidget(text: "Hi ^.^ I'm Mini Dino"),
      ];

  bool showDinos = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...(showDinos
                      ? myDinosContent(returnImageColor)
                      : mintContent(onClaim)),
                  const SizedBox(height: 30),
                  IntroButtonWidget(
                    text: 'Log out',
                    onPressed: () => logout(context),
                    size: 'fit',
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    while (GoRouter.of(context).canPop() == true) {
      GoRouter.of(context).pop();
    }
    GoRouter.of(context).pushReplacement("/");
    // await storage.delete(key: 'mnemonic');
  }

  void onClaim() {
    setState(() {
      showDinos = true;
    });
  }

  Image returnImageColor(int index) {
    if (index == 0) {
      return Image.asset(
        'assets/images/logo.jpeg',
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        colorBlendMode: BlendMode.color,
      );
    }

    return Image.asset(
      'assets/images/logo.jpeg',
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.color,
      color: filters[index],
    );
  }
}
