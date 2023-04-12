import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final snackbarProvider =
    ChangeNotifierProvider<SnackbarNotifier>((ref) => SnackbarNotifier());

class SnackbarNotifier extends ChangeNotifier {
  String? msg;

  show(String m) {
    print('Snackbar> $msg');
    msg = m;
    notifyListeners();
  }
}
