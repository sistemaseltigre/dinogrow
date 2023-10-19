import 'package:flutter/material.dart';

class TextBoxWidget extends StatelessWidget {
  final String text;

  const TextBoxWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: const Color.fromRGBO(241, 189, 57, 1), width: 6),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
