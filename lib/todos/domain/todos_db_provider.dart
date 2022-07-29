import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/data/fs_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final todosDbProvider = FutureProvider<IDbService>((ref) async {
  final db = FsDbService();
  if (Platform.isAndroid) {
    await db.init(dbPath: "/storage/emulated/0/TagsTodosOrganizer");
  }
  if (Platform.isLinux) {
    await db.init(dbPath: "/home/lavruh/Documents/TaggedTodosOrganizer");
  }
  return db;
});
