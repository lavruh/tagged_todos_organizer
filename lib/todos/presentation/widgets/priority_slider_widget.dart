import 'package:flutter/material.dart';

class PrioritySliderWidget extends StatefulWidget {
  const PrioritySliderWidget({
    super.key,
    required this.initValue,
    required this.setValue,
  });
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
          child: AnimatedCrossFade(
            firstChild: Container(),
            secondChild: IconButton(
                onPressed: () => widget.setValue(value.round()),
                icon: const Icon(Icons.check)),
            crossFadeState: widget.initValue == value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500),
          ),
        )
      ],
    );
  }
}
