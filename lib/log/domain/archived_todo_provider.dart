import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final archivedTodoProvider =
    FutureProvider.family<ToDo, UniqueId>((ref, id) async {
  final appPath = ref.watch(appPathProvider);
  final archivePath = p.join(appPath, 'archive', '${id.id}.zip');
  final file = File(archivePath);
  if (!file.existsSync()) {
    throw Exception('Archive for todo $id not found at $archivePath');
  }

  final bytes = await file.readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);

  for (final file in archive) {
    if (file.name == 'data.json') {
      final data = utf8.decode(file.content as List<int>);
      final map = json.decode(data);
      return ToDo.fromMap(map);
    }
  }

  throw Exception('data.json not found in archive for todo $id');
});

final archivedAttachmentsProvider =
    FutureProvider.family<List<ArchiveFile>, UniqueId>((ref, id) async {
  final appPath = ref.watch(appPathProvider);
  final archivePath = p.join(appPath, 'archive', '${id.id}.zip');
  final file = File(archivePath);
  if (!file.existsSync()) {
    return [];
  }

  final bytes = await file.readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);
  return archive.where((f) => f.isFile && f.name != 'data.json').toList();
});
