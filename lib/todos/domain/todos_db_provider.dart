import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/fs_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final todosDbProvider = FutureProvider<IDbService>((ref) async {
  final db = FsDbService();
  await db.init(dbPath: ref.watch(appPathProvider));
  return db;
});
