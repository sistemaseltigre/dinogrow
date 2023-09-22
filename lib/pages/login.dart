import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool validationFailed = false;
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 40),
          Center(
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 200,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != password) {
                          setState(() {
                            validationFailed = true;
                          });
                          return;
                        }
                        GoRouter.of(context).push("/home");
                        return null;
                        // Validation
                      }),
                  const SizedBox(height: 8),
                  Text(validationFailed ? 'Invalid Password' : '',
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onDifferentAccountPressed(context);
                      },
                      child: const Text('Use different Account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }
}
