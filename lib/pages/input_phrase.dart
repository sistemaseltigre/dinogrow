import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;

import 'package:dinogrow/pages/setup_password.dart';
import '../ui/widgets/widgets.dart';

class InputPhraseScreen extends StatefulWidget {
  const InputPhraseScreen({super.key});

  @override
  State<InputPhraseScreen> createState() => _InputPhraseScreenState();
}

class _InputPhraseScreenState extends State<InputPhraseScreen> {
  final _formKey = GlobalKey<FormState>();
  var controllers =
      List<TextEditingController>.generate(12, (i) => TextEditingController());

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    controllers.forEach((controller) {
      controller.addListener(() {
        if (controller.text.contains(' ')) {
          final words = controller.text.split(' ');
          int counter = 0;

          words.forEach((element) {
            controllers[counter].text = element;
            counter++;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controllers[0].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ui/config_jungle_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: SizedBox()),
                  const TextBoxWidget(
                      text: 'Please enter your recovery phrase'),
                  const Expanded(child: SizedBox()),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                          child: GridView.count(
                        padding: const EdgeInsets.all(3),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 3,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: List.generate(12, (index) {
                          return SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: controllers[index],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: '${index + 1}',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          );
                        }),
                      )),
                    ),
                  ),
                  IntroButtonWidget(
                    text: 'Continue',
                    onPressed: () {
                      _onSubmit(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(context) async {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      // String wordsString = _words.join(' ');
      String wordsString = '';

      for (var controller in controllers) {
        wordsString = '$wordsString${controller.text} ';
      }

      wordsString = wordsString.substring(0, wordsString.length - 1);

      final t = bip39.validateMnemonic(wordsString);

      if (t) {
        // GoRouter.of(context).push("/passwordSetup/$wordsString");
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SetupPasswordScreen(mnemonic: wordsString);
          },
        );
      } else {
        const snackBar = SnackBar(
          content: Text(
            'Error: Invalid keyphrase',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
