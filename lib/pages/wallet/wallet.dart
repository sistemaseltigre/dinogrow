import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../ui/widgets/widgets.dart';

class WalletScreen extends StatelessWidget {
  final String address;
  final String? balance;

  const WalletScreen({super.key, required this.address, this.balance});

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
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: QrImageView(
                        data: address,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        "Your address: $address",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  IntroButtonWidget(
                    text: 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: address));
                      const snackBar = SnackBar(
                        content: Text('Copied!'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
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
