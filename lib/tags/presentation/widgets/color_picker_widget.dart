import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    super.key,
    required this.initColor,
    required this.onSet,
  });
  final int initColor;
  final Function(int) onSet;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: MaterialPicker(
        pickerColor: Color(initColor),
        onColorChanged: (val) {
          onSet(val.toARGB32());
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
