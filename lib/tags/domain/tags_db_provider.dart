import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:path/path.dart' as p;

final tagsDbProvider = FutureProvider<IDbService>((ref) async {

  final dbPath = ref.watch(appPathProvider);
  final db = SembastDbService();
  await Directory(p.join(dbPath, 'tags')).create();
  try {
    await db.init(dbPath: dbPath);
  } on Exception catch (e) {
    ref.read(snackbarProvider.notifier).show('Error: $e');
  }
  return db;
});
