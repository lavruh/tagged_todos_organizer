import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

final tagsDbProvider = FutureProvider<IDbService>((ref) async {
  final db = SembastDbService();
  try {
    if (Platform.isAndroid) {
      await db.init(dbPath: "/storage/emulated/0/TagsTodosOrganizer");
    }
    if (Platform.isLinux) {
      await db.init(dbPath: "/home/lavruh/Documents/TaggedTodosOrganizer");
    }
  } on Exception catch (e) {
    ref.read(snackbarProvider.notifier).show('Error: $e');
  }
  return db;
});
