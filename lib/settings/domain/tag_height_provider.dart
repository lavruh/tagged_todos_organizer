import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final tagHeightProvider = Provider<double>((ref) {
  if (Platform.isLinux) {
    return 0.03;
  }
  return 0.045;
});
