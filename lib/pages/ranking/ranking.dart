import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solana/solana.dart';
import 'package:solana/dto.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:solana_common/borsh/borsh.dart' as solana_borsh;
import '../../anchor_types/dino_score_info.dart' as anchor_types_dino;
import '../../anchor_types/dino_game_info.dart' as anchor_types_dino_game;
import '../../ui/widgets/widgets.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final storage = const FlutterSecureStorage();
  List<ItemsProps> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const TextBoxWidget(
                      text:
                          "We'll announce the prizes to each winner on our social networks, please stay connected."),
                  const SizedBox(height: 12),
                  const IntroButtonWidget(
                    text: 'Visit us',
                    onPressed: _launchUrl,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: const Color.fromRGBO(241, 189, 57, 1),
                            width: 6),
                      ),
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: getRanking,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  items.sort((a, b) => double.parse(b.gamescore)
                                      .compareTo(double.parse(a.gamescore)));

                                  final item = items[index];

                                  return ListTile(
                                    leading: index < 3
                                        ? Icon(
                                            Icons.emoji_events,
                                            color: prizeColors[index],
                                            size: 36,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(42),
                                            child: item.imageUrl.isNotEmpty
                                                ? Image.network(
                                                    item.imageUrl,
                                                    width: 42,
                                                  )
                                                : Image.asset(
                                                    'assets/images/logo.jpeg',
                                                    width: 42,
                                                  ),
                                          ),
                                    title: Text(
                                        '${item.playerPubkey.substring(0, 5)}...${item.playerPubkey.substring(item.playerPubkey.length - 5, item.playerPubkey.length)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    trailing: Text(item.gamescore,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> getRanking() async {
    try {
      List<ItemsProps> items2save = [];

      setState(() {
        loading = true;
      });

      //Get rank from blockchain
      await dotenv.load(fileName: ".env");

      SolanaClient? client;
      client = SolanaClient(
        rpcUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
        websocketUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_WSS'].toString()),
      );

      final programId = dotenv.env['PROGRAM_ID'].toString();

      // Obtener todas las cuentas del programa
      final accounts = await client.rpcClient.getProgramAccounts(
        programId,
        encoding: Encoding.jsonParsed,
      );

      // Recorre las cuentas y muestra los datos
      for (var account
          in (accounts.length <= 15 ? accounts : accounts.sublist(0, 15))) {
        final bytes = account.account.data as BinaryAccountData;

        //Get Score
        final decoderDataScore = anchor_types_dino.DinoScoreArguments.fromBorsh(
            bytes.data as Uint8List);

        //Get Game Data
        final decoderDataGame =
            anchor_types_dino_game.DinoGameArguments.fromBorsh(
                bytes.data as Uint8List);

        String? localImgUrl =
            await storage.read(key: '${decoderDataGame.dinoPubkey}');

        if (localImgUrl == null) {
          final response = await http.post(
              Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
              headers: <String, String>{
                'Content-Type': 'application/json',
                "x-qn-api-version": '1'
              },
              body: jsonEncode({
                "method": "qn_fetchNFTs",
                "params": {
                  "wallet": '${decoderDataGame.playerPubkey}',
                  "page": 1,
                  "perPage": 10
                }
              }));

          final dataResponse = jsonDecode(response.body);

          if (dataResponse.isNotEmpty) {
            final arrayAssets = dataResponse['result']['assets'];
            final indexNft = arrayAssets.indexWhere((item) =>
                item["tokenAddress"] == '${decoderDataGame.dinoPubkey}');
            String imgurl = indexNft > -1
                ? arrayAssets[int.parse('$indexNft')]['imageUrl']
                : '';

            await storage.write(
                key: '${decoderDataGame.dinoPubkey}', value: imgurl);

            items2save.add(ItemsProps(
                imageUrl: imgurl,
                dinoPubkey: '${decoderDataGame.dinoPubkey}',
                gamescore: '${decoderDataScore.gamescore}',
                playerPubkey: '${decoderDataGame.playerPubkey}'));
          } else {
            items2save.add(ItemsProps(
                imageUrl: '',
                dinoPubkey: '${decoderDataGame.dinoPubkey}',
                gamescore: '${decoderDataScore.gamescore}',
                playerPubkey: '${decoderDataGame.playerPubkey}'));
          }
        } else {
          items2save.add(ItemsProps(
              imageUrl: localImgUrl,
              dinoPubkey: '${decoderDataGame.dinoPubkey}',
              gamescore: '${decoderDataScore.gamescore}',
              playerPubkey: '${decoderDataGame.playerPubkey}'));
        }
      }

      setState(() {
        items = items2save;
      });
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          'Error: $e',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}

List prizeColors = List.generate(
    3,
    (index) =>
        index == 0 ? Colors.orange : (index == 1 ? Colors.grey : Colors.brown));

class ItemsProps {
  String imageUrl;
  String playerPubkey;
  String gamescore;
  String dinoPubkey;

  ItemsProps(
      {required this.playerPubkey,
      required this.gamescore,
      required this.imageUrl,
      required this.dinoPubkey});
}

Future<void> _launchUrl() async {
  Uri url = Uri(scheme: 'https', host: 'x.com', path: '/din0gr0w');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
