import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:solana/dto.dart';
import 'package:dinogrow/pages/upload_to_ipfs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:io';
import 'package:solana_common/utils/buffer.dart' as solana_buffer;
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solana/solana.dart';
import 'package:solana/solana.dart' as solana;
import 'package:url_launcher/url_launcher.dart';
import '../ui/widgets/widgets.dart';
import 'package:solana/anchor.dart' as solana_anchor;
import 'package:solana/encoder.dart' as solana_encoder;
import '../anchor_types/put_profile_info.dart' as anchor_types_parameters;
import '../anchor_types/get_profile_info.dart' as anchor_types_parameters_get;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final bioController = TextEditingController();
  final statusController = TextEditingController();
  String? password;
  bool _loading = true;
  String? key;
  final storage = const FlutterSecureStorage();
  File imageProfile = File('');
  String beforeImageProfile = '';
  String methodprogram = "saveprofile";

  @override
  void initState() {
    super.initState();

    _checkForSavedLogin().then((credentialsFound) {
      if (!credentialsFound) {
        GoRouter.of(context).push("/setup");
      } else {
        getInitialInfo();
      }
    });
  }

  Widget build(BuildContext context) {
    String localImgUrl =
        imageProfile.path.isNotEmpty ? imageProfile.path : beforeImageProfile;

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                GoRouter.of(context).replace('/home');
              },
            ),
          ),
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
                                fit: localImgUrl.isNotEmpty
                                    ? BoxFit.cover
                                    : BoxFit.scaleDown,
                                image: localImgUrl.isNotEmpty
                                    ? (imageProfile.path.isNotEmpty
                                        ? Image.file(
                                            imageProfile,
                                            fit: BoxFit.cover,
                                          ).image
                                        : (beforeImageProfile.isNotEmpty
                                            ? Image.network(beforeImageProfile)
                                                .image
                                            : const AssetImage(
                                                'assets/images/icons/add_image.png')))
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
        ),
      ),
    );
  }

  Future getInitialInfo() async {
    try {
      setState(() {
        _loading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      final findprofileb = await findprofile();
      if (findprofileb != null) {
        nicknameController.text = findprofileb.nickname;
        bioController.text = findprofileb.bio;
        statusController.text = findprofileb.status;

        if (findprofileb.uri.toString().isEmpty) {
          setState(() {
            methodprogram = "updateprofile";
          });
        } else {
          setState(() {
            methodprogram = "updateprofile";
            beforeImageProfile =
                'https://quicknode.myfilebase.com/ipfs/${findprofileb.uri}';
          });
        }
      } else {
        setState(() {
          methodprogram = "saveprofile";
        });
      }
    } catch (e) {
      ShowProps alert = ShowProps()
        ..text = 'Error get profile data ($e)'
        ..context = context
        ..scaffoldMessengerKey = scaffoldMessengerKey
        ..backgroundColor = Colors.red;

      SnakAlertWidget().show(alert);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imageProfile = imageTemp;
        beforeImageProfile = '';
      });
    } catch (e) {
      ShowProps alert = ShowProps()
        ..text = 'Failed to pick image: $e'
        ..context = context
        ..scaffoldMessengerKey = scaffoldMessengerKey
        ..backgroundColor = Colors.red;

      SnakAlertWidget().show(alert);
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
      ShowProps alert = ShowProps()
        ..text = 'Error: Please fill all fields to continue'
        ..context = context
        ..scaffoldMessengerKey = scaffoldMessengerKey
        ..backgroundColor = Colors.red;

      SnakAlertWidget().show(alert);
    }
  }

  void _onSubmit() async {
    try {
      setState(() {
        _loading = true;
      });

      String? cid = '';

      if (!imageProfile.existsSync()) {
        var bytes = await rootBundle.load('assets/images/icons/no_user.png');
        String tempPath = (await getTemporaryDirectory()).path;
        File file = File('$tempPath/profile.png');
        final localImage = await file.writeAsBytes(
            bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

        setState(() {
          imageProfile = localImage;
        });
      }

      if (beforeImageProfile.isEmpty) {
        cid = await uploadToIPFS(imageProfile);
      } else {
        cid = beforeImageProfile.replaceAll(
            RegExp('https://quicknode.myfilebase.com/ipfs/'), '');
      }
      //save profile
      await dotenv.load(fileName: ".env");

      SolanaClient? client;
      client = SolanaClient(
        rpcUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
        websocketUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_WSS'].toString()),
      );
      const storage = FlutterSecureStorage();

      final mainWalletKey = await storage.read(key: 'mnemonic');

      final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
        mainWalletKey!,
      );

      //Generate internal wallet
      String dinoString = dotenv.env['DINO_KEY'].toString();
      dinoString = dinoString.replaceAll(RegExp(r'\[|\]'), '');
      List<String> valueStrings = dinoString.split(',');
      List<int> integerList =
          (valueStrings).map((value) => int.parse(value)).toList();
      Uint8List secretKey = Uint8List.fromList(integerList);
      final keypair = await web3.Keypair.fromSecretKey(secretKey);
      //path: "m/44'/501'/0'/0'/0'",
      String hdPath = dotenv.env['HD_PATH'].toString();
      final walletdino = await solana.Ed25519HDKeyPair.fromSeedWithHdPath(
          seed: keypair.secretKey, hdPath: hdPath);

      final programId = dotenv.env['PROGRAM_ID'].toString();
      final systemProgramId =
          solana.Ed25519HDPublicKey.fromBase58(solana.SystemProgram.programId);

      final programIdPublicKey =
          solana.Ed25519HDPublicKey.fromBase58(programId);

      final dprofilePda = await solana.Ed25519HDPublicKey
          .findProgramAddress(programId: programIdPublicKey, seeds: [
        solana_buffer.Buffer.fromString(dotenv.env['PROFILE_SEED'].toString()),
        mainWalletSolana.publicKey.bytes,
      ]);

      final instructions = [
        await solana_anchor.AnchorInstruction.forMethod(
          programId: programIdPublicKey,
          method: methodprogram,
          arguments: solana_encoder.ByteArray(
              anchor_types_parameters.PutProfileArguments(
            nickname: nicknameController.text,
            bio: bioController.text,
            status: statusController.text,
            uri: cid as String,
          ).toBorsh().toList()),
          accounts: <solana_encoder.AccountMeta>[
            solana_encoder.AccountMeta.writeable(
                pubKey: dprofilePda, isSigner: false),
            solana_encoder.AccountMeta.writeable(
                pubKey: mainWalletSolana.publicKey, isSigner: true),
            solana_encoder.AccountMeta.readonly(
                pubKey: systemProgramId, isSigner: false),
            solana_encoder.AccountMeta.writeable(
                pubKey: walletdino.publicKey, isSigner: true),
          ],
          namespace: 'global',
        ),
      ];
      final message = solana.Message(instructions: instructions);
      final signature = await client.sendAndConfirmTransaction(
        message: message,
        signers: [mainWalletSolana, walletdino],
        commitment: solana.Commitment.confirmed,
      );

      showResultMessage(signature);

      ShowProps alert = ShowProps()
        ..text = 'Profile updated'
        ..context = context
        ..scaffoldMessengerKey = scaffoldMessengerKey
        ..backgroundColor = Colors.green;

      SnakAlertWidget().show(alert);
    } catch (e) {
      ShowProps alert = ShowProps()
        ..text = 'Failed to save data: $e'
        ..context = context
        ..backgroundColor = Colors.red
        ..scaffoldMessengerKey = scaffoldMessengerKey;

      SnakAlertWidget().show(alert);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  findprofile() async {
    await dotenv.load(fileName: ".env");

    SolanaClient? client;
    client = SolanaClient(
      rpcUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
      websocketUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_WSS'].toString()),
    );
    const storage = FlutterSecureStorage();

    final mainWalletKey = await storage.read(key: 'mnemonic');

    final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
      mainWalletKey!,
    );

    final programId = dotenv.env['PROGRAM_ID'].toString();

    final programIdPublicKey = solana.Ed25519HDPublicKey.fromBase58(programId);

    final dprofilePda = await solana.Ed25519HDPublicKey
        .findProgramAddress(programId: programIdPublicKey, seeds: [
      solana_buffer.Buffer.fromString(dotenv.env['PROFILE_SEED'].toString()),
      mainWalletSolana.publicKey.bytes,
    ]);

    // Obtener todas las cuentas del programa
    final accountprofile = await client.rpcClient
        .getAccountInfo(
          dprofilePda.toBase58(),
          encoding: Encoding.base64,
        )
        .value;

    if (accountprofile != null) {
      final bytes = accountprofile.data as BinaryAccountData;
      final decodeAllData =
          anchor_types_parameters_get.GetProfileArguments.fromBorsh(
              bytes.data as Uint8List);
      return decodeAllData;
    } else {
      return null;
    }
  }

  showResultMessage(String transaction) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Profile updated'),
        content: Text(
            "You can review information on blockchain with this transaction reference: \n\n$transaction"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _launchUrl(transaction);
            },
            child: const Text('View transaction'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(String transaction) async {
  Uri url = Uri(
      scheme: 'https',
      host: 'explorer.solana.com',
      path: '/tx/$transaction',
      queryParameters: {'cluster': 'devnet'});
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
