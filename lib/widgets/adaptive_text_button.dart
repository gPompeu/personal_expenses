import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final Function handler;
  final bool isIOS;

  AdaptiveTextButton(this.text, this.handler, this.isIOS);

  @override
  Widget build(BuildContext context) {
    return isIOS
        ? CupertinoButton(
            child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: handler,
          )
        : TextButton(child: Text(text), onPressed: handler);
  }
}
