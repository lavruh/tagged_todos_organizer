import 'package:flutter/material.dart';

class PrioritySliderWidget extends StatefulWidget {
  const PrioritySliderWidget({
    Key? key,
    required this.initValue,
    required this.setValue,
  }) : super(key: key);
  final int initValue;
  final Function(int) setValue;
  @override
  State<PrioritySliderWidget> createState() => _PrioritySliderWidgetState();
}

class _PrioritySliderWidgetState extends State<PrioritySliderWidget> {
  double value = 0;

  @override
  void initState() {
    value = widget.initValue.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('$value'),
        Slider(
          label: 'Priority',
          value: value,
          onChanged: (val) {
            value = val;
            setState(() {});
          },
          min: 0,
          max: 10,
          divisions: 10,
          secondaryTrackValue: 1,
        ),
        SizedBox.square(
          dimension: 40,
          child: IconButton(
              onPressed: () => widget.setValue(value.round()),
              icon: Icon(Icons.check)),
        )
      ],
    );
  }
}
