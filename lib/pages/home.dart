import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:solana/solana.dart';

import 'dart:typed_data';
import 'package:solana/dto.dart';
import 'dart:async';
import 'package:solana_common/utils/buffer.dart' as solana_buffer;
import 'package:solana/solana.dart' as solana;
import '../ui/widgets/widgets.dart';
import '../anchor_types/get_profile_info.dart' as anchor_types_parameters_get;

import 'package:dinogrow/pages/my-dinogrow/my_dinogrow.dart';
import 'package:dinogrow/pages/mini-games/mini_games.dart';
import 'package:dinogrow/pages/ranking/ranking.dart';
import 'package:dinogrow/pages/wallet/wallet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nickName;
  String? _publicKey;
  String? _balance;
  SolanaClient? client;
  String imageProfile = '';

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _readPk();
    getInitialInfo();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(241, 189, 57, 1),
          elevation: 6,
          toolbarHeight: 122 + (statusBarHeight > 0 ? 41 : 0) - statusBarHeight,
          flexibleSpace: Column(
            children: [
              SizedBox(height: statusBarHeight),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).replace('/profile');
                },
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.white,
                  elevation: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 6, bottom: 6, left: 12, right: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(42),
                          child: imageProfile.isEmpty
                              ? Image.asset(
                                  'assets/images/icons/no_user.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageProfile,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              (nickName ?? '(No nickname)'),
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _publicKey == null
                                  ? 'Loading...'
                                  : '${_publicKey!.substring(0, 6)}...${_publicKey!.substring(_publicKey!.length - 6, _publicKey!.length)}',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                            )
                          ],
                        )),
                        const SizedBox(width: 12),
                        const Text(
                          'Balance: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(width: 3),
                        Text(
                            _balance != null
                                ? double.parse(_balance ?? '0')
                                    .toStringAsFixed(2)
                                : 'Loading...',
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black)),
                        const SizedBox(width: 3),
                        const Text('SOL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
              const TabBar(
                unselectedLabelColor: Color.fromRGBO(34, 38, 59, 1),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    height: 60,
                    icon: Icon(
                      Icons.videogame_asset,
                      size: 18,
                    ),
                    text: 'Games',
                    iconMargin: EdgeInsets.all(6),
                  ),
                  Tab(
                    height: 60,
                    icon: Icon(
                      Icons.emoji_events,
                      size: 18,
                    ),
                    text: 'Ranking',
                    iconMargin: EdgeInsets.all(6),
                  ),
                  Tab(
                    height: 60,
                    icon: Icon(
                      Icons.pets,
                      size: 18,
                    ),
                    text: 'My Dino',
                    iconMargin: EdgeInsets.all(6),
                  ),
                  Tab(
                    height: 60,
                    icon: Icon(
                      Icons.wallet,
                      size: 18,
                    ),
                    text: 'Wallet',
                    iconMargin: EdgeInsets.all(6),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ui/intro_jungle_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const MiniGamesScreen(),
              const RankingScreen(),
              MydinogrowScreen(
                  address: _publicKey ?? '', getBalance: () => _getBalance()),
              WalletScreen(
                  address: _publicKey ?? '',
                  balance: _balance,
                  getBalance: () => _getBalance()),
            ],
          ),
        ),
      ),
    );
  }

  void _readPk() async {
    final mnemonic = await storage.read(key: 'mnemonic');
    if (mnemonic != null) {
      final keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
      setState(() {
        _publicKey = keypair.address;
      });
      _initializeClient();
    }
  }

  void _initializeClient() async {
    await dotenv.load(fileName: ".env");

    client = SolanaClient(
      rpcUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
      websocketUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_WSS'].toString()),
    );
    _getBalance();
  }

  void _getBalance() async {
    setState(() {
      _balance = null;
    });
    final getBalance = await client?.rpcClient
        .getBalance(_publicKey!, commitment: Commitment.confirmed);
    final balance = (getBalance!.value) / lamportsPerSol;
    setState(() {
      _balance = balance.toString();
    });
  }

  Future getInitialInfo() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final findprofileb = await findprofile();

      if (findprofileb != null) {
        setState(() {
          nickName = findprofileb.nickname;
        });

        if (findprofileb.uri.toString().isNotEmpty) {
          setState(() {
            imageProfile =
                'https://quicknode.myfilebase.com/ipfs/${findprofileb.uri}';
          });
        }
      }
    } catch (e) {
      ShowProps alert = ShowProps()
        ..text = 'Error get profile data ($e)'
        ..context = context
        ..backgroundColor = Colors.red;

      SnakAlertWidget().show(alert);
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
}
