import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;

import 'package:dinogrow/pages/setup_password.dart';
import '../ui/widgets/widgets.dart';

class GeneratePhraseScreen extends StatefulWidget {
  const GeneratePhraseScreen({super.key});

  @override
  State<GeneratePhraseScreen> createState() => _GeneratePhraseScreenState();
}

class _GeneratePhraseScreenState extends State<GeneratePhraseScreen> {
  String _mnemonic = "";
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Recovery Phrase")),
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ui/config_jungle_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(23),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 60),
              Container(
                color: Colors.orange[700],
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Important! Copy and save the recovery phrase in a secure location. This cannot be recovered later.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              TextBoxWidget(text: _mnemonic),
              IntroButtonWidget(
                text: 'Copy phrase',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _mnemonic));
                  const snackBar = SnackBar(
                    content: Text('Copied!'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _copied,
                        onChanged: (value) {
                          setState(() {
                            _copied = value!;
                          });
                        },
                      ),
                      const Text("I have stored the recovery phrase securely"),
                    ],
                  )),
              IntroButtonWidget(
                text: 'Continue',
                variant: _copied ? 'primary' : 'disabled',
                onPressed: _copied
                    ? () {
                        // GoRouter.of(context).push("/passwordSetup/$_mnemonic");
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SetupPasswordScreen(mnemonic: _mnemonic);
                          },
                        );
                      }
                    : () {},
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateMnemonic() async {
    String mnemonic = bip39.generateMnemonic();

    setState(() {
      _mnemonic = mnemonic;
    });
  }
}
