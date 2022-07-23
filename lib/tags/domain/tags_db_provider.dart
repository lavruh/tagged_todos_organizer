import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/data/hive_db_service.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final tagsDbProvider = FutureProvider<IDbService>((ref) async {
  final db = HiveDbService();
  await db.init('tags');
  return db;
});
