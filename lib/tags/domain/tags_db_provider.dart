import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/data/hive_tags_db_service.dart';
import 'package:tagged_todos_organizer/tags/data/i_tags_db_service.dart';

final tagsDbProvider = FutureProvider<ITagsDbService>((ref) async {
  final db = HiveTagsDbService();
  await db.init();
  return db;
});
