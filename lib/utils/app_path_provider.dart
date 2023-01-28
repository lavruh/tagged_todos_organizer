import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appPathProvider = Provider<String>((ref) {
  return getAppFolderPath();
});

String getAppFolderPath() {
  final appName = "TaggedTodosOrganizer";
  if (Platform.isAndroid) {
    return "/storage/emulated/0/$appName";
  }
  if (Platform.isLinux) {
    return "/home/lavruh/Documents/$appName";
  }
  return '/';
}
