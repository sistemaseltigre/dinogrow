import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui/widgets/widgets.dart';

class RankingScreen extends StatelessWidget {
  RankingScreen({super.key});

  final List<ItemsProps> items = List<ItemsProps>.generate(
    20,
    (i) => ItemsProps(wallet: 'User $i', score: (i * 100).toString()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ui/intro_jungle_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return ListTile(
                            leading: index < 3
                                ? Icon(
                                    Icons.emoji_events,
                                    color: prizeColors[index],
                                  )
                                : null,
                            title: Text(item.wallet,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            trailing: Text(item.score,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

List prizeColors = List.generate(
    3,
    (index) =>
        index == 0 ? Colors.orange : (index == 1 ? Colors.grey : Colors.brown));

class ItemsProps {
  String wallet;
  String score;

  ItemsProps({required this.wallet, required this.score});
}

Future<void> _launchUrl() async {
  Uri url = Uri(scheme: 'https', host: 'x.com', path: '/din0gr0w');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
