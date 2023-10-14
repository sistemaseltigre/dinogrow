import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../ui/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  String? password;
  bool _loading = true;
  String? key;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _checkForSavedLogin().then((credentialsFound) {
      if (!credentialsFound) {
        GoRouter.of(context).push("/setup");
      } else {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ui/intro_jungle_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const IntroLogoWidget(),
                    const SizedBox(height: 30),
                    const TextBoxWidget(
                        text:
                            'To continue, please enter your current password'),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 8),
                          IntroButtonWidget(
                            text: 'Login',
                            onPressed: _onSubmit,
                          ),
                          const SizedBox(height: 32),
                          IntroButtonWidget(
                            text: 'Use different Account',
                            onPressed: () {
                              onDifferentAccountPressed(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkForSavedLogin() async {
    key = await storage.read(key: 'mnemonic');
    password = await storage.read(key: 'password');
    if (key == null || password == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<dynamic> onDifferentAccountPressed(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'Access to current account will be lost if seed phrase is lost.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).push("/setup");
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void _onSubmit() async {
    setState(() {
      _loading = true;
    });
    if (passwordController.text == password) {
      await Future.delayed(const Duration(seconds: 1));
      while (GoRouter.of(context).canPop() == true) {
        GoRouter.of(context).pop();
      }
      GoRouter.of(context).pushReplacement("/home");
    } else {
      const snackBar = SnackBar(
        content: Text(
          'Error: Invalid Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        _loading = false;
      });
    }
  }
}
