import 'package:flutter/material.dart';

class IntroButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? size;

  const IntroButtonWidget({
    super.key,
    this.onPressed,
    required this.text,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: size == 'fit' ? null : const Size.fromHeight(50),
        backgroundColor: const Color.fromRGBO(241, 189, 57, 1),
        padding: const EdgeInsets.all(18),
        shadowColor: Colors.purple,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: const BorderSide(
          width: 3,
          color: Color.fromRGBO(34, 38, 59, 1),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Color.fromRGBO(34, 38, 59, 1),
            fontWeight: FontWeight.bold,
            fontSize: 24),
      ),
    );
  }
}
