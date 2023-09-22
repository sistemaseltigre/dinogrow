import 'dart:math';

import 'package:flutter/material.dart';

class IntroLogoWidget extends StatefulWidget {
  const IntroLogoWidget({
    super.key,
  });

  @override
  State<IntroLogoWidget> createState() => _IntroLogoWidgetState();
}

class _IntroLogoWidgetState extends State<IntroLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double rotateIt(double value) {
    return pi / 2 * (0.5 - (0.5 - Curves.ease.transform(value)).abs());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.rotate(
        angle: rotateIt(controller.value),
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 6,
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(120),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(120),
          child: Image.asset(
            'assets/images/logo.jpeg',
            width: 240,
          ),
        ),
      ),
    );
  }
}
