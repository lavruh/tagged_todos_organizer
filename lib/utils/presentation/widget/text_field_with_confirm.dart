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
      contextMenuBuilder: (context, editableTextState) {
        final customButtons = [
          ContextMenuButtonItem(
              onPressed: () => _deleteString(editableTextState),
              label: "Delete String"),
          ContextMenuButtonItem(
              onPressed: () => _toggleDone(editableTextState),
              label: "Toggle done"),
        ];

        final buttons = [
          ...customButtons,
          ...editableTextState.contextMenuButtonItems
        ];
        return AdaptiveTextSelectionToolbar.buttonItems(
            buttonItems: buttons,
            anchors: editableTextState.contextMenuAnchors);
      },
    );
  }

  void _deleteString(EditableTextState editableTextState) {
    final fieldText = editableTextState.currentTextEditingValue.text;
    final selection = editableTextState.currentTextEditingValue.selection;
    setState(() {
      controller.text = fieldText.replaceAll(
        _getRowUnderCursor(fieldText, selection.start),
        "",
      );
    });
  }

  _toggleDone(EditableTextState editableTextState) {
    final fieldText = editableTextState.currentTextEditingValue.text;
    final selection = editableTextState.currentTextEditingValue.selection;

    const checked = "☒";
    const check = "☐";

    final selText = _getRowUnderCursor(fieldText, selection.start);
    final startSymbol = selText[0];
    String updatedString = "";
    if (startSymbol != check || startSymbol != checked) {
      updatedString = "$check $selText";
    }
    if (startSymbol == check) {
      updatedString = selText.replaceFirst(check, checked);
    }
    if (startSymbol == checked) {
      updatedString = selText.replaceFirst(checked, check);
    }

    setState(() {
      controller.text = fieldText.replaceFirst(selText, updatedString);
    });
  }

  String _getRowUnderCursor(String text, int cursorPosition) {
    final rows = text.split('\n');
    int startOfRow = 0;
    for (final s in rows) {
      final endOfRow = s.length + startOfRow + 1;
      if (startOfRow <= cursorPosition && endOfRow > cursorPosition) {
        startOfRow += s.length + 1;
        return "$s\n";
      }
      startOfRow += s.length + 1;
    }
    return "";
  }
}
