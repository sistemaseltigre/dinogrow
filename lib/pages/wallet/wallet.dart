import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui/widgets/widgets.dart';

class WalletScreen extends StatelessWidget {
  final String? address;
  final String? balance;

  const WalletScreen({super.key, this.address, this.balance});

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
                  Row(children: [
                    Expanded(
                        child: TextBoxWidget(text: 'Your address: $address')),
                    const SizedBox(width: 12),
                    IntroButtonWidget(
                      text: 'Copy',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: address ?? ''));
                        const snackBar = SnackBar(
                          content: Text('Copied!'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      size: 'fit',
                    )
                  ]),
                  const SizedBox(height: 30),
                  Row(children: [
                    Expanded(
                        child: TextBoxWidget(text: 'Balace: $balance SOL')),
                    const SizedBox(width: 12),
                    IntroButtonWidget(
                      text: 'Send',
                      onPressed: () {},
                      size: 'fit',
                    )
                  ]),
                  const SizedBox(height: 30),
                ]),
          ),
        ),
      ),
    );
  }
}
