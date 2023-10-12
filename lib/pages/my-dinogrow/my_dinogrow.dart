import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../ui/widgets/widgets.dart';

class MydinogrowScreen extends StatefulWidget {
  final String address;

  const MydinogrowScreen({super.key, required this.address});

  @override
  State<MydinogrowScreen> createState() => _MydinogrowScreenState();
}

class _MydinogrowScreenState extends State<MydinogrowScreen> {
  final storage = const FlutterSecureStorage();
  bool _loading = true;
  var userNfts = [];
  int nftSelected = 0;

  final filters = [
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    )
  ];

  List<Widget> mintContent(_onClaim) => [
        const IntroLogoWidget(),
        const SizedBox(height: 30),
        IntroButtonWidget(
          text: 'Claim your Dino',
          onPressed: _onClaim,
        ),
        const SizedBox(height: 30),
        Container(
          color: Colors.orange[700],
          padding: const EdgeInsets.all(8),
          child: const Text(
            'Wait ... you must to have a Dino to start play our games, so "Claim your Dino" is our last step to auto-generate your first NFT!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
      ];

  List<Widget> myDinosContent(returnImageColorFc) => [
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: userNfts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    nftSelected = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: nftSelected == index
                          ? Colors.white
                          : Colors.transparent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Image.network(
                      userNfts[index]['imageUrl'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.color,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: Colors.black,
                          width: 120,
                          height: 120,
                        );
                      },
                    ),
                    // child: returnImageColorFc(index),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        GameCardWidget(
          text: userNfts.isNotEmpty ? userNfts[nftSelected]['name'] : '',
          urlImage:
              userNfts.isNotEmpty ? userNfts[nftSelected]['imageUrl'] : '',
        ),
        // const SizedBox(height: 30),
        // TextBoxWidget(text: "Hi ^.^ I'm $nameNft"),
      ];

  bool showDinos = false;

  @override
  void initState() {
    super.initState();
    fetchNfts();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

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
                  ...(showDinos && userNfts.isNotEmpty
                      ? myDinosContent(returnImageColor)
                      : mintContent(onClaim)),
                  const SizedBox(height: 30),
                  IntroButtonWidget(
                    text: 'Log out',
                    onPressed: () => logout(context),
                    size: 'fit',
                    variant: 'disabled',
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    while (GoRouter.of(context).canPop() == true) {
      GoRouter.of(context).pop();
    }
    GoRouter.of(context).pushReplacement("/");
    // await storage.delete(key: 'mnemonic');
  }

  void onClaim() {
    setState(() {
      showDinos = true;
    });
  }

  Image returnImageColor(int index) {
    if (index == 0) {
      return Image.asset(
        'assets/images/logo.jpeg',
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        colorBlendMode: BlendMode.color,
      );
    }

    return Image.asset(
      'assets/images/logo.jpeg',
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.color,
      color: filters[index],
    );
  }

  Future<void> fetchNfts() async {
    try {
      setState(() {
        _loading = true;
      });

      await dotenv.load(fileName: ".env");

      final response = await http.post(
          Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "x-qn-api-version": '1'
          },
          body: jsonEncode({
            "method": "qn_fetchNFTs",
            "params": {
              "wallet": widget.address,
              // "AUMbL5J7wQuNxV7tpj1mq4SzPxqReDA6VzfkCzpJjcUi",
              "page": 1,
              "perPage": 10
            }
          }));

      final dataResponse = jsonDecode(response.body);
      final arrayAssets = dataResponse['result']['assets'];

      setState(() {
        userNfts = arrayAssets.where((nft) => nft['imageUrl'] != '').toList();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
