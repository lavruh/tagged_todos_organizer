import 'package:flutter/material.dart';

class TextFieldWithConfirm extends StatefulWidget {
  const TextFieldWithConfirm({
    super.key,
    required this.text,
    required this.onConfirm,
    this.maxLines,
    this.lable,
    this.keyboardType,
    this.suffix,
    this.border,
  });
  final String text;
  final Function(String) onConfirm;
  final int? maxLines;
  final String? lable;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final InputBorder? border;

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
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.lable,
        border: widget.border,
        suffix: controller.text != widget.text
            ? IconButton(
                onPressed: () => widget.onConfirm(controller.text),
                icon: const Icon(Icons.check),
              )
            : widget.suffix,
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}
