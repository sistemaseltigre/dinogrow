import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:go_router/go_router.dart';

class GeneratePhraseScreen extends StatefulWidget {
  const GeneratePhraseScreen({super.key});

  @override
  State<GeneratePhraseScreen> createState() => _GeneratePhraseScreenState();
}

class _GeneratePhraseScreenState extends State<GeneratePhraseScreen> {
  String _mnemonic = "";
  Icon iconButton = const Icon(Icons.copy);
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _generateMnemonic();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recovery Phrase")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              color: Colors.orange[700],
              padding: EdgeInsets.all(8),
              child: const Text(
                'Important! Copy and save the recovery phrase in a secure location. This cannot be recovered later.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    _mnemonic,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _mnemonic));
                      setState(() {
                        iconButton = const Icon(Icons.check);
                      });
                    },
                    icon: iconButton,
                  ),
                ],
              ),
              Row(
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
              ),
              ElevatedButton(
                onPressed: _copied
                    ? () {
                        GoRouter.of(context).go("/passwordSetup/$_mnemonic");
                      }
                    : () {
                        GoRouter.of(context).go("/");
                      },
                child: Text(_copied ? 'Continue' : 'Go Back'),
              )
            ],
          ),
        ],
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