import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

class FsDbService implements IDbService {
  late Directory root;
  @override
  Future<void> add(
      {required Map<String, dynamic> item, required String table}) async {
    final id = item['id'];
    if (id == null) {
      throw Exception('Item has no ID');
    }
    await update(id: id, item: item, table: table);
  }

  @override
  Future<void> delete({required String id, required String table}) async {
    final dir = Directory(await findPath(path: id));
    if (await dir.exists()) {
      dir.delete(recursive: true);
    }
  }

  @override
  Future<void> deleteTable({required String table}) async {
    await delete(id: table, table: table);
  }

  @override
  Stream<Map<String, dynamic>> getAll({required String table}) async* {
    final dir = Directory(await findPath(path: table));
    await for (final item in dir.list(recursive: false)) {
      if (item is Directory) {
        Map<String, dynamic>? data;
        List<String> attachements = [];
        for (final file in item.listSync()) {
          if (file is File) {
            if (p.basename(file.path) == 'data.json') {
              data = fromJson(await file.readAsString());
            } else {
              attachements.add(file.path);
            }
          }
        }
        if (data != null) {
          data['attacments'] = attachements;
          yield data;
        }
      }
    }
  }

  @override
  Future<void> init({required String dbPath}) async {
    try {
      root = Directory(dbPath);
      await Directory(p.join(dbPath, 'todos')).create();
      await Directory(p.join(dbPath, 'tags')).create();
    } on Exception catch (e) {
      throw FsDbException('Can not open db path [$dbPath], $e');
    }
  }

  @override
  Future<void> update(
      {required String id,
      required Map<String, dynamic> item,
      required String table}) async {
    final folderName = id;
    final dirPath = p.join(await findPath(path: table), folderName);
    await Directory(dirPath).create();
    await File(p.join(dirPath, 'data.json')).writeAsString(toJson(item));
  }

  String toJson(Map<String, dynamic> map) => json.encode(map);

  Map<String, dynamic> fromJson(String source) => json.decode(source);

  clearDb() async {
    final content = root.list();
    await for (var item in content) {
      if (item is Directory) {
        await item.delete(recursive: true);
      }
      if (item is File) {
        await item.delete();
      }
    }
  }

  Future<String> findPath({required String path}) async {
    if (path == '/') {
      return root.path;
    }
    await for (final item in root.list(recursive: true)) {
      if (p.basename(item.path) == path) {
        return item.path;
      }
    }
    throw (FsDbException('No item with id $path found'));
  }
}

class FsDbException implements Exception {
  String msg;
  FsDbException(this.msg);
  @override
  String toString() => 'FsDbException: $msg';
}
