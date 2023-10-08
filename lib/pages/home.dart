import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';

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
  String? _publicKey;
  String? _balance;
  SolanaClient? client;
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _readPk();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(241, 189, 57, 1),
          elevation: 6,
          toolbarHeight: 120,
          flexibleSpace: Column(
            children: [
              const SizedBox(height: 38),
              Card(
                color: Colors.white,
                shadowColor: Colors.white,
                elevation: 9,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Text(
                        'User: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                          child: Text(
                        _publicKey == null
                            ? 'Loading...'
                            : '${_publicKey!.substring(0, 6)}...${_publicKey!.substring(_publicKey!.length - 6, _publicKey!.length)}',
                        style: const TextStyle(color: Colors.black),
                      )),
                      const SizedBox(width: 12),
                      const Text(
                        'Balance: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(width: 3),
                      Text(_balance ?? 'Loading...',
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
              const TabBar(
                unselectedLabelColor: Color.fromRGBO(34, 38, 59, 1),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    icon: Icon(Icons.videogame_asset),
                    text: 'Games',
                  ),
                  Tab(
                    icon: Icon(Icons.emoji_events),
                    text: 'Ranking',
                  ),
                  Tab(
                    icon: Icon(Icons.pets),
                    text: 'My Dino',
                  ),
                  Tab(
                    icon: Icon(Icons.wallet),
                    text: 'Wallet',
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
            children: [
              const MiniGamesScreen(),
              RankingScreen(),
              const MydinogrowScreen(),
              WalletScreen(address: _publicKey ?? '', balance: _balance),
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
}
