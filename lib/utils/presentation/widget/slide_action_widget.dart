import 'package:flutter/material.dart';

class SlideActionWidget extends StatefulWidget {
  const SlideActionWidget({
    super.key,
    required this.child,
    this.slideRightLabel,
    this.slideLeftLabel,
    this.onSlideRight,
    this.onSlideLeft,
  });
  final Widget child;
  final String? slideRightLabel;
  final String? slideLeftLabel;
  final Function()? onSlideRight;
  final Function()? onSlideLeft;

  @override
  State<SlideActionWidget> createState() => _SlideActionWidgetState();
}

class _SlideActionWidgetState extends State<SlideActionWidget> {
  double opacity = 1.0;
  final actionSP = 0.1;
  int initDirection = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        final dx = d.delta.dx;
        final direction = dx > 0 ? -1 : 1;
        if (initDirection == 0) initDirection = direction;
        final add = dx * 0.004 * initDirection;
        final newOpacity = opacity + add;
        setState(() {
          if (newOpacity > 0 && newOpacity < 1) opacity = newOpacity;
        });
      },
      onPanEnd: (d) {
        final direction = initDirection;
        if (opacity < actionSP) {
          if (direction < 0) widget.onSlideRight?.call();
          if (direction > 0) widget.onSlideLeft?.call();
        }
        setState(() {
          opacity = 1.0;
          initDirection = 0;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: opacity,
            child: widget.child,
          ),
          Opacity(
            opacity: 1 - opacity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  initDirection > 0
                      ? Text(widget.slideLeftLabel ?? '')
                      : Container(),
                  initDirection < 0
                      ? Text(widget.slideRightLabel ?? '')
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
