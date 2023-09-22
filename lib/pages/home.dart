import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:solana/solana.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('DINOGROW'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // User card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text('User'),
                    Text(_publicKey == null
                        ? 'Loading...'
                        : '${_publicKey!.substring(0, 4)}...${_publicKey!.substring(_publicKey!.length - 3, _publicKey!.length)}'),
                    Text(_balance ?? 'Loading...'),
                  ],
                ),
              ),
            ),

            // menu card
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextButton(
                      child: Text('My Dinogrow'),
                      onPressed: () {
                        // My Dinos button
                      },
                    ),
                    TextButton(
                      child: Text('Mini Games'),
                      onPressed: () {
                        GoRouter.of(context).push("/mini_games");
                      },
                    ),
                    TextButton(
                      child: Text('Wallet'),
                      onPressed: () {
                        // wallet button
                      },
                    ),
                    TextButton(
                      child: Text('Ranking'),
                      onPressed: () {
                        // Ranking button
                      },
                    )
                  ],
                ),
              ),
            ),

            // logout card
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text('Log Out'),
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        GoRouter.of(context).push("/");
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
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
