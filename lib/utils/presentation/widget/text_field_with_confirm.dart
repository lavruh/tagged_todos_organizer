import 'package:flutter/material.dart';

class TextFieldWithConfirm extends StatefulWidget {
  const TextFieldWithConfirm({
    super.key,
    required this.text,
    required this.onConfirm,
    this.maxLines,
    this.lable,
  });
  final String text;
  final Function(String) onConfirm;
  final int? maxLines;
  final String? lable;

  @override
  State<TextFieldWithConfirm> createState() => _TextFieldWithConfirmState();
}

class _TextFieldWithConfirmState extends State<TextFieldWithConfirm> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.lable,
        suffix: controller.text != widget.text
            ? IconButton(
                onPressed: () => widget.onConfirm(controller.text),
                icon: const Icon(Icons.check),
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}
