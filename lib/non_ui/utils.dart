import 'package:flutter/material.dart';

class Utlis {
  static void showSnackbar(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$title")));
  }
}
