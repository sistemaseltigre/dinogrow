import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../ui/widgets/widgets.dart';

class SetupPasswordScreen extends StatefulWidget {
  final String? mnemonic;
  SetupPasswordScreen({super.key, required this.mnemonic});

  @override
  State<SetupPasswordScreen> createState() => _SetupPasswordScreenState();
}

class _SetupPasswordScreenState extends State<SetupPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color.fromRGBO(34, 38, 59, 1)),
          title: const Text(
            'Set Up Password',
            style: TextStyle(color: Color.fromRGBO(34, 38, 59, 1)),
          ),
          backgroundColor: const Color.fromRGBO(241, 189, 57, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(children: [
                TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm password is required';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }),
                const SizedBox(height: 42),
                IntroButtonWidget(
                  text: 'Submit',
                  onPressed: _submit,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      print("validate");
      if (passwordController.text != confirmPasswordController.text) {
        return;
      }

      await storage.write(key: 'password', value: passwordController.text);
      await storage.write(key: 'mnemonic', value: widget.mnemonic);

      GoRouter.of(context).push("/");
    }
  }
}
