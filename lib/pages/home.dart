import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';

import 'package:dinogrow/pages/my-dinogrow/my_dinogrow.dart';
import 'package:dinogrow/pages/mini-games/mini_games.dart';
import 'package:dinogrow/pages/ranking/ranking.dart';
import 'package:dinogrow/pages/wallet/wallet.dart';
// import 'package:dinogrow/pages/coming_soon.dart';

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
                        'Wallet: ',
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
                    icon: Icon(Icons.wallet),
                    text: 'Wallet',
                  ),
                  Tab(
                    icon: Icon(Icons.pets),
                    text: 'My Dino',
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
              WalletScreen(address: _publicKey, balance: _balance),
              const MydinogrowScreen(),
            ],
          ),
        ),
      ),
    );

    // Scaffold(
    //   body: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: ListView(
    //       children: [
    //         // User card
    //         Card(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8),
    //             child: Column(
    //               children: [
    //                 const Text('User'),
    //                 Text(_publicKey == null
    //                     ? 'Loading...'
    //                     : '${_publicKey!.substring(0, 4)}...${_publicKey!.substring(_publicKey!.length - 3, _publicKey!.length)}'),
    //                 Text(_balance ?? 'Loading...'),
    //               ],
    //             ),
    //           ),
    //         ),

    //         // menu card
    //         Card(
    //           child: Padding(
    //             padding: EdgeInsets.all(8),
    //             child: Column(
    //               children: [
    //                 TextButton(
    //                   child: Text('My Dinogrow'),
    //                   onPressed: () {
    //                     // My Dinos button
    //                   },
    //                 ),
    //                 TextButton(
    //                   child: Text('Mini Games'),
    //                   onPressed: () {
    //                     GoRouter.of(context).push("/mini_games");
    //                   },
    //                 ),
    //                 TextButton(
    //                   child: Text('Wallet'),
    //                   onPressed: () {
    //                     // wallet button
    //                   },
    //                 ),
    //                 TextButton(
    //                   child: Text('Ranking'),
    //                   onPressed: () {
    //                     // Ranking button
    //                   },
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),

    //         // logout card
    //         Card(
    //           child: Padding(
    //             padding: EdgeInsets.all(8),
    //             child: Row(
    //               children: [
    //                 Text('Log Out'),
    //                 IconButton(
    //                   icon: Icon(Icons.logout),
    //                   onPressed: () {
    //                     GoRouter.of(context).push("/");
    //                   },
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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
