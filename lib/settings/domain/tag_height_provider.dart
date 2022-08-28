import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final tagHeightProvider = Provider<double>((ref) {
  if (Platform.isLinux) {
    return 0.035;
  }
  return 0.06;
});
