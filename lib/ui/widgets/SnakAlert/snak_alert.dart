import 'package:flutter/material.dart';

class ShowProps {
  late BuildContext context;
  late String text;
  late Color backgroundColor;
  late GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
}

class SnakAlertWidget {
  void show(ShowProps props) {
    SnackBar snackBar = SnackBar(
      content: Text(
        props.text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: props.backgroundColor,
    );

    if (props.scaffoldMessengerKey != null) {
      props.scaffoldMessengerKey?.currentState?.showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(props.context).showSnackBar(snackBar);
    }
  }
}
