import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

Future<String?> inputDialog(
  BuildContext context, {
  required String title,
  String? text,
}) async {
  final res = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: TextFieldWithConfirm(
              text: text ?? '',
              onConfirm: (val) => Navigator.of(context).pop(val),
            ),
          ));
  return res;
}
