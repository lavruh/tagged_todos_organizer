import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final snackbarProvider =
    ChangeNotifierProvider<SnackbarNotifier>((ref) => SnackbarNotifier());

class SnackbarNotifier extends ChangeNotifier {
  String? msg;

  void show(String m) {
    msg = m;
    notifyListeners();
  }
}
