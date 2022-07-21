import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    Key? key,
    required this.initColor,
    required this.onSet,
  }) : super(key: key);
  final int initColor;
  final Function(int) onSet;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: MaterialPicker(
        pickerColor: Color(initColor),
        onColorChanged: (val) {
          onSet(val.value);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
