import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';

final todosDbProvider = FutureProvider<IDbService>((ref) async {
  final db = SembastDbService();
  if (Platform.isAndroid) {
    await db.init(
        table: 'todos', dbPath: "/storage/emulated/0/TagsTodosOrganizer");
  }
  if (Platform.isLinux) {
    await db.init(
        table: 'todos', dbPath: "/home/lavruh/Documents/TaggedTodosOrganizer");
  }
  return db;
});
