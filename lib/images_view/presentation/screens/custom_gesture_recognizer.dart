import 'package:flutter/gestures.dart';

class HorizontalSwipeGestureRecognizer extends OneSequenceGestureRecognizer {
  @override
  String get debugDescription => '';
  final double screenWidth;
  final double sensableAreaWidth = 20;
  final Function? onSwipeLeft;
  final Function? onSwipeRight;
  late Offset _initPoint;
  HorizontalSwipeGestureRecognizer({
    required this.screenWidth,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  void addPointer(PointerDownEvent event) {
    final x = event.position.dx;
    if ((x >= sensableAreaWidth) && (x <= (screenWidth - sensableAreaWidth))) {
      stopTrackingPointer(event.pointer);
    } else {
      _initPoint = event.position;
      startTrackingPointer(event.pointer, event.transform);
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      final delta = _initPoint - event.position;
      if (delta.dx > 0) {
        if (onSwipeLeft != null) onSwipeLeft!();
      }
      if (delta.dx < 0) {
        if (onSwipeRight != null) onSwipeRight!();
      }
    }
  }
}
