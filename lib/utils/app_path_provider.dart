import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appPathProvider = Provider<String>((ref) {
  if (Platform.isAndroid) {
    return "/storage/emulated/0/TagsTodosOrganizer";
  }
  if (Platform.isLinux) {
    return "/home/lavruh/Documents/TaggedTodosOrganizer";
  }
  return '/';
});
