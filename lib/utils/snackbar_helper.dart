import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
