import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetUpScreen extends StatelessWidget {
  const SetUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/inputphrase'),
              child: const Text('I have a recovery Phrase'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/generatePhrase'),
              child: const Text('Generate new wallet'),
            ),
          ],
        ),
      ),
    );
  }
}