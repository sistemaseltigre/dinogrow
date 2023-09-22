import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar appBar(BuildContext context) => AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          context.pop();
        },
      ),
    );
