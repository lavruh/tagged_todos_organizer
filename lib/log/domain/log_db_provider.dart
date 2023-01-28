import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:path/path.dart' as p;

final logDbProvider = FutureProvider<IDbService>((ref) async {
  final db = SembastDbService();
  try {
    final appPath = ref.watch(appPathProvider);
    await db.init(dbPath: p.join(appPath, 'log'));
  } on Exception catch (e) {
    ref.read(snackbarProvider.notifier).show('Error: $e');
  }
  return db;
});
