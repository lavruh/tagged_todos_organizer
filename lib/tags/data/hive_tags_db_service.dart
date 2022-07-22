import 'package:hive_flutter/hive_flutter.dart';
import 'package:tagged_todos_organizer/tags/data/i_tags_db_service.dart';

class HiveTagsDbService implements ITagsDbService {
  Box<Map<dynamic, dynamic>>? box;

  init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('tags');
  }

  @override
  Future<void> addTag({required Map<String, dynamic> item}) async {
    final key = item['id'];
    if (key != null) {
      box?.put(key, item);
    } else {
      box?.add(item);
    }
  }

  @override
  Future<void> deleteTag({required String id}) async {
    box?.delete(id);
  }

  @override
  Stream<Map<String, dynamic>> getTags() async* {
    final entries = box?.values.toList();
    if (entries != null) {
      for (final item in entries) {
        final m = Map<String, dynamic>.from(item).map((key, value) {
          if (value.runtimeType == String || value.runtimeType == int) {
            return MapEntry(key, value);
          } else {
            return MapEntry(key, Map<String, dynamic>.from(value));
          }
        });
        yield m;
      }
    }
  }

  @override
  Future<void> updateTag(
      {required String id, required Map<String, dynamic> item}) async {
    box?.put(id, item);
  }
}
