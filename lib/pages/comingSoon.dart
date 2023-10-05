import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/widgets/widgets.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ui/intro_jungle_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
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
                    text: 'Log out',
                    onPressed: () {
                      while (GoRouter.of(context).canPop() == true) {
                        GoRouter.of(context).pop();
                      }
                      GoRouter.of(context).pushReplacement("/");
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
