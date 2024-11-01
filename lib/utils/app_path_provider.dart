import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/main.dart';

final appPathProvider = Provider<String>((ref) => appRootPath);

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
