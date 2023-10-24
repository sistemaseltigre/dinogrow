import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:io';

import '../ui/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final bioController = TextEditingController();
  final statusController = TextEditingController();
  String? password;
  bool _loading = false;
  String? key;
  final storage = const FlutterSecureStorage();
  File imageProfile = File('');

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
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
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
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            scale: 3,
                            fit: imageProfile.path.isNotEmpty
                                ? BoxFit.cover
                                : BoxFit.scaleDown,
                            image: imageProfile.path.isNotEmpty
                                ? Image.file(
                                    imageProfile,
                                    fit: BoxFit.cover,
                                  ).image
                                : const AssetImage(
                                    'assets/images/icons/add_image.png'),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 6),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    const TextBoxWidget(
                        text:
                            'Edit your profile to share it to our community ^.^'),
                    const Expanded(child: SizedBox()),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: nicknameController,
                            decoration: InputDecoration(
                              labelText: 'Nickname',
                              filled: true,
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: bioController,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              filled: true,
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: statusController,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              filled: true,
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          IntroButtonWidget(
                            text: 'Save',
                            onPressed: () => onWant2Save(context),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imageProfile = imageTemp;
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
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

  void onWant2Save(BuildContext context) {
    if (nicknameController.text.isNotEmpty &&
        bioController.text.isNotEmpty &&
        statusController.text.isNotEmpty) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update profile transaction'),
              content: const Text(
                  'Before to continue, are you sure to dave your data? Remember the transaction has a variable cost so please confirm if you have at least 0.05 SOL in your wallet balance.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onSubmit();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          });
    } else {
      const snackBar = SnackBar(
        content: Text(
          'Error: Please fill all fields to continue',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _onSubmit() async {
    try {
      setState(() {
        _loading = true;
      });

      // TODO update profile
      GoRouter.of(context).pop();
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
