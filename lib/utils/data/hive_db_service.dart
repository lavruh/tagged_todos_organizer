import 'package:hive_flutter/hive_flutter.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

class HiveDbService implements IDbService {
  Box<Map<dynamic, dynamic>>? box;

  @override
  init(String table) async {
    await Hive.initFlutter();
    box = await Hive.openBox(table);
  }

  @override
  Future<void> add({required Map<String, dynamic> item}) async {
    final key = item['id'];
    if (key != null) {
      box?.put(key, item);
    } else {
      box?.add(item);
    }
  }

  @override
  Future<void> delete({required String id}) async {
    box?.delete(id);
  }

  @override
  Stream<Map<String, dynamic>> getAll() async* {
    final entries = box?.values.toList();
    if (entries != null) {
      for (final item in entries) {
        final m = Map<String, dynamic>.from(item).map((key, value) {
          if (value.runtimeType == String ||
              value.runtimeType == int ||
              value.runtimeType == bool ||
              value.runtimeType == Null ||
              value.runtimeType == List ||
              value.runtimeType == List<String>) {
            return MapEntry(key, value);
          } else if (value.runtimeType == Map<dynamic, dynamic>) {
            return MapEntry(key, Map<String, dynamic>.from(value));
          } else {
            return MapEntry(key, null);
          }
        });
        yield m;
      }
    }
  }

  @override
  Future<void> update(
      {required String id, required Map<String, dynamic> item}) async {
    box?.put(id, item);
  }
}
