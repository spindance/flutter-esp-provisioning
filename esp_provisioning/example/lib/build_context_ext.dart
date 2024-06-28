import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  void showSimpleSnackBar(String message) => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(backgroundColor: Theme.of(this).primaryColor, content: Text(message)),
      );
}
