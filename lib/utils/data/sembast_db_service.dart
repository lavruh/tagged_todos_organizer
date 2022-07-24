import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

class SembastDbService implements IDbService {
  final String _dbName = 'tagged_todos_organizer';
  Database? _db;
  late StoreRef store;

  @override
  Future<void> init({required String table, required String dbPath}) async {
    store = StoreRef(table);
    try {
      final path = p.join(dbPath, "$_dbName.db");
      _db = await databaseFactoryIo.openDatabase(path);
    } on PlatformException {
      throw Exception('Failed to open DB');
    }
  }

  @override
  Future<void> add({required Map<String, dynamic> item}) async {
    await _db?.transaction(
      (transaction) async => await store.add(transaction, item),
    );
  }

  @override
  Future<void> delete({required String id}) async {
    await _db?.transaction(
      (transaction) async => await store.record(id).delete(transaction),
    );
  }

  @override
  Stream<Map<String, dynamic>> getAll() async* {
    if (_db != null) {
      final data = await store.find(_db!);
      for (final item in data) {
        final Map<String, dynamic> m = {};
        m.addAll(item.value);
        yield m;
      }
    }
  }

  @override
  Future<void> update(
      {required String id, required Map<String, dynamic> item}) async {
    await _db?.transaction(
      (transaction) async {
        await store.record(id).put(transaction, item);
      },
    );
  }
}
