import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagged_todos_organizer/utils/domain/string_extension.dart';

class TextFieldWithConfirm extends StatefulWidget {
  const TextFieldWithConfirm({
    super.key,
    required this.text,
    required this.onConfirm,
    this.maxLines,
    this.label,
    this.keyboardType,
    this.suffix,
    this.border,
    this.textAlign,
    this.textStyle,
    this.confirmButtonLocation = Axis.horizontal,
    this.autoSaveDuration = const Duration(seconds: 7),
  });
  final String text;
  final Function(String) onConfirm;
  final int? maxLines;
  final String? label;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final InputBorder? border;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final Axis confirmButtonLocation;
  final Duration autoSaveDuration;

  @override
  State<TextFieldWithConfirm> createState() => _TextFieldWithConfirmState();
}

class _TextFieldWithConfirmState extends State<TextFieldWithConfirm> {
  final controller = TextEditingController();
  bool get hasToSave => widget.text != controller.text;
  Timer? autoSaveTimer;

  @override
  void initState() {
    controller.text = widget.text;
    controller.addListener(_activateAutoSaveTimer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: FocusNode(),
      onKeyEvent: (fn, e) {
        if (e is KeyDownEvent && e.logicalKey.keyLabel == "Enter") {
          _onEnterPressedHandler();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        direction: widget.confirmButtonLocation,
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              textAlign: widget.textAlign ?? TextAlign.start,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              stylusHandwritingEnabled: true,
              style: widget.textStyle,
              decoration: InputDecoration(
                labelText: widget.label,
                border: widget.border,
                isDense: true,
                suffix: widget.suffix,
              ),
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
            ),
          ),
          if (hasToSave)
            IconButton(
              onPressed: _save,
              icon: const Icon(Icons.check),
            )
        ],
      ),
    );
  }

  void _save() {
    if (hasToSave) {
      widget.onConfirm(controller.text);
      autoSaveTimer?.cancel();
      autoSaveTimer = null;
    }
  }

  void _deleteString(EditableTextState editableTextState) {
    controller.value = controller.value.deleteRowUnderCursor();
    setState(() {});
  }

  void _toggleDone(EditableTextState editableTextState) {
    controller.value = controller.value.checkRowUnderCursor();
    setState(() {});
  }

  void _onEnterPressedHandler() {
    controller.value = controller.value.customEnterHandler();
    setState(() {});
  }

  void _activateAutoSaveTimer() {
    autoSaveTimer?.cancel();
    autoSaveTimer = Timer(widget.autoSaveDuration, _save);
    setState(() {});
  }
}
