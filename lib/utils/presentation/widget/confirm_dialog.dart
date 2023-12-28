import 'package:flutter/material.dart';

Future<bool?> confirmDialog(BuildContext context,
    {required String title}) async {
  final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            actions: [
              IconButton(
                  key: const Key('dialog_confirm'),
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check)),
              IconButton(
                  key: const Key('dialog_cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.cancel)),
            ],
          ));
  return res;
}
