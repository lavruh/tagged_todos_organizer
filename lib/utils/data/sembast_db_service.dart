import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

class SembastDbService implements IDbService {
  final String _dbName = 'tagged_todos_organizer';
  Database? _db;

  @override
  Future<void> init({required String dbPath}) async {
    try {
      final path = p.join(dbPath, "$_dbName.db");
      _db = await databaseFactoryIo.openDatabase(path);
    } on PlatformException {
      throw Exception('Failed to open DB');
    }
  }

  @override
  Future<void> add({
    required Map<String, dynamic> item,
    required String table,
  }) async {
    final store = StoreRef(table);
    await _db?.transaction(
      (transaction) async => await store.add(transaction, item),
    );
  }

  @override
  Future<void> delete({
    required String id,
    required String table,
  }) async {
    final store = StoreRef(table);
    final Map<String, String> children = await getChildrenIds(id);
    await _db?.transaction(
      (transaction) async {
        await store.record(id).delete(transaction);
      },
    );
    for (final e in children.entries) {
      await deleteTable(table: e.value);
    }
  }

  @override
  Future<void> deleteTable({required String table}) async {
    final store = StoreRef(table);
    if (_db != null) {
      await store.delete(_db!);
    }
  }

  @override
  Stream<Map<String, dynamic>> getAll({
    required String table,
  }) async* {
    if (_db != null) {
      final store = StoreRef(table);
      final data = await store.find(_db!);
      for (final item in data) {
        final Map<String, dynamic> m = {};
        m.addAll(item.value as Map<String, dynamic>);
        yield m;
      }
    }
  }

  @override
  Future<void> update({
    required String id,
    required Map<String, dynamic> item,
    required String table,
  }) async {
    final store = StoreRef(table);
    if (item['id'] != null && id != item['id']) {
      await delete(id: id, table: table);
      await update(id: item['id'], item: item, table: table);
    } else {
      await _db?.transaction(
        (transaction) async {
          await store.record(id).put(transaction, item);
        },
      );
    }
  }

  Future<Map<String, String>> getChildrenIds(String id) async {
    final Map<String, String> ids = {};
    await for (final child in getAll(table: id)) {
      final childId = child['id'];
      if (childId != null) {
        ids.putIfAbsent(childId, () => id);
        ids.addAll(await getChildrenIds(childId));
      }
    }
    return ids;
  }

  closeAndDeleteDb() async {
    if (_db != null) {
      await _db!.close();
      await databaseFactoryIo.deleteDatabase(_db!.path);
      _db = null;
    }
  }

  @override
  Future<Map<String, dynamic>> getItemByFieldValue({
    required Map<String, String> request,
    required String table,
  }) async {
    if (_db != null) {
      final store = StoreRef(table);
      final finder = Finder(
          filter: Filter.matches(
        request.keys.first,
        request.values.first,
      ));
      final res = await store.findFirst(_db!, finder: finder);
      if (res != null) {
        return res.value as Map<String, dynamic>;
      }
    }
    return {};
  }
}
