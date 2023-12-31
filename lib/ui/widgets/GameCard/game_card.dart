import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameCardWidget extends StatelessWidget {
  final String text;
  final String? route;
  final String? urlImage;
  final Image? localImage;

  const GameCardWidget({
    super.key,
    required this.text,
    this.route,
    this.urlImage,
    this.localImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          GoRouter.of(context).push(route!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: const Color.fromRGBO(241, 189, 57, 1), width: 6),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (urlImage ?? '').isNotEmpty
                  ? Image.network(
                      urlImage ?? '',
                      width: 120,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: Image.asset(
                            'assets/images/logo.jpeg',
                            width: 120,
                          ),
                        );
                      },
                    )
                  : localImage ??
                      Image.asset(
                        'assets/images/logo.jpeg',
                        width: 120,
                      ),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
