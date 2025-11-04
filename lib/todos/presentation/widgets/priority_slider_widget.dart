import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';

class PrioritySliderWidget extends StatefulWidget {
  const PrioritySliderWidget({
    super.key,
    required this.initValue,
    required this.setValue,
    this.title = "",
  });
  final int initValue;
  final String title;
  final Function(int) setValue;
  @override
  State<PrioritySliderWidget> createState() => _PrioritySliderWidgetState();
}

class _PrioritySliderWidgetState extends State<PrioritySliderWidget> {
  int value = 0;

  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (value < 10 && value >= 0) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${widget.title}:$value'),
            Slider(
              label: widget.title,
              value: value.toDouble(),
              onChanged: (v) {
                _changeValue(v.toInt());
                _confirm();
              },
              min: 0,
              max: 10,
              divisions: 10,
              secondaryTrackValue: 1,
            ),
          ]);
    }

    return Center(
      child: SizedBox(
          width: 80,
          child: TextFieldWithConfirm(
            text: value.toString(),
            keyboardType: TextInputType.number,
            maxLines: 1,
            textAlign: TextAlign.center,
            onConfirm: (v) {
              final val = int.tryParse(v);
              if (val != null && val >= 0 && val <= 100) {
                _changeValue(val);
                _confirm();
              }
            },
          )),
    );
  }

  void _changeValue(int val) => setState(() => value = val);

  void _confirm() => widget.setValue(value.round());
}
