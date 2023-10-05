import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../ui/widgets/widgets.dart';

class ComingSoonScreen extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ui/intro_jungle_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const IntroLogoWidget(),
                  const SizedBox(height: 30),
                  const TextBoxWidget(text: 'Coming soon ^-^'),
                  const SizedBox(height: 30),
                  IntroButtonWidget(
                    text: 'Return',
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    size: 'fit',
                  ),
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
}
