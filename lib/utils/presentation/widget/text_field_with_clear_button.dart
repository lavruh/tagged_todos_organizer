import 'package:flutter/material.dart';

class TextFieldWithClearButton extends StatefulWidget {
  const TextFieldWithClearButton(
      {super.key, this.initText, required this.onChanged});
  final String? initText;
  final Function(String) onChanged;

  @override
  State<TextFieldWithClearButton> createState() =>
      _TextFieldWithClearButtonState();
}

class _TextFieldWithClearButtonState extends State<TextFieldWithClearButton> {
  bool isNotEmpty = false;
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.initText ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: textController,
        onChanged: (v) {
          widget.onChanged(v);
          if (v.isNotEmpty) {
            setState(() => isNotEmpty = true);
          } else {
            setState(() => isNotEmpty = false);
          }
        },
        decoration: InputDecoration(
          labelText: 'Search',
          icon: isNotEmpty == false
              ? const Icon(Icons.filter_alt)
              : IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    widget.onChanged('');
                    setState(() {
                      textController.text = '';
                      isNotEmpty = false;
                    });
                  },
                ),
        ));
  }
}
