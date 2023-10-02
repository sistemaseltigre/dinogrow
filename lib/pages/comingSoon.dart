import 'package:flutter/material.dart';

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
        child: const Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IntroLogoWidget(),
                SizedBox(height: 30),
                TextBoxWidget(text: 'Coming soon ^-^'),
              ]),
        ),
      ),
    );
  }
}
