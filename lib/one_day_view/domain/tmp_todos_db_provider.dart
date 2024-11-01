import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/fs_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:path/path.dart' as p;

final tmpTodosDbProvider = FutureProvider<IDbService>((ref) async {
  final dbPath = ref.watch(appPathProvider);
  await Directory(p.join(dbPath, 'tmp_todos')).create();
  final db = FsDbService();
  await db.init(dbPath: dbPath);
  return db;
});
