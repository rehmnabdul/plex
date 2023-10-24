import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension SnackBarUtils on BuildContext {
  showSnackBar(String message) {
    if (!mounted) return;
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 400.0,
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(this).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  copyToClipboard(String text, {bool showCopiedInfo = true}) {
    Clipboard.setData(ClipboardData(text: text));
    if (showCopiedInfo) showSnackBar("Text copied on clipboard");
  }
}
