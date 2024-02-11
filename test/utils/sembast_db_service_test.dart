import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import 'package:path/path.dart' as p;

const dbPath = '/home/lavruh/tmp/test';
const String dbName = 'tagged_todos_organizer';

void main() {
  final dbfile = p.join(dbPath, "$dbName.db");
  final sut = SembastDbService();

  tearDown(() async {
    await sut.closeAndDeleteDb();
  });
  test('add entry', () async {
    await sut.init(dbPath: dbPath);
    await sut.update(id: 'id1', item: {'item': 'data'}, table: '/');
    final file = await File(dbfile).readAsString();
    expect(file, contains('id1'));
    expect(file, contains('data'));
    expect(file, contains('/'));
  });

  test('add and delete root item', () async {
    const testId = 'idd2';
    await sut.init(dbPath: dbPath);
    await sut.update(id: testId, item: {'item2': 'data2'}, table: '/');
    final file = await File(dbfile).readAsString();
    expect(file, contains(testId));
    await sut.delete(id: testId, table: '/');
    final res = sut.getAll(table: '/');
    expect(res, emitsDone);
  });

  test('add and delete table', () async {
    const testId = 'idd3';
    const testTable = 'someTable';
    await sut.init(dbPath: dbPath);
    await sut.update(id: testId, item: {'item3': 'data3'}, table: testTable);
    final file = await File(dbfile).readAsString();
    expect(file, contains(testTable));
    await sut.delete(id: testId, table: testTable);
    await sut.deleteTable(table: testTable);
    final res = sut.getAll(table: testTable);
    expect(res, emitsDone);
  });

  test('Get item children table and ids', () async {
    const rootID = 'root';
    const subID = 'sub1';
    final sut = SembastDbService();
    await sut.init(dbPath: dbPath);
    const Map<String, String> result = {
      rootID: '/',
      subID: rootID,
      'sub2': rootID,
      'sub sub': subID,
    };
    for (final map in result.entries) {
      await sut.update(id: map.key, item: {'id': map.key}, table: map.value);
    }

    final r = await sut.getChildrenIds(rootID);
    r.putIfAbsent(rootID, () => '/');
    expect(r, result);
  });

  test('delete id and its children', () async {
    const rootID = 'root';
    const extraId = 'extraId';
    const subID = 'sub1';
    final sut = SembastDbService();
    await sut.init(dbPath: dbPath);
    const Map<String, String> result = {
      rootID: '/',
      extraId: '/',
      subID: rootID,
      'sub2': rootID,
      'sub sub': subID,
    };
    for (final map in result.entries) {
      await sut.update(id: map.key, item: {'id': map.key}, table: map.value);
    }

    await sut.delete(id: rootID, table: '/');
    expect(sut.getAll(table: '/'), emits({'id': extraId}));
    expect(sut.getAll(table: rootID), emitsDone);
    expect(sut.getAll(table: subID), emitsDone);
  });

  test('get item by field value', () async {
    final sut = SembastDbService();
    await sut.init(dbPath: dbPath);
    final testData = {'maximoNo': '6.123.123', 'name:': 'kasldkjalskd'};
    final testData2 = {'maximoNo': '6.123.132', 'name:': 'kasldkjalskd'};
    await sut.add(item: testData, table: 'parts');
    await sut.add(item: testData2, table: 'parts');

    final result = await sut.getItemByFieldValue(
      request: {'maximoNo': '6.123.123'},
      table: 'parts',
    );
    expect(result, testData);
  });

  test('update method should change ID if it does not equal item["id"]', () async {
    final sut = SembastDbService();
    await sut.init(dbPath: dbPath);
    const id = 'id1';
    final Map<String, dynamic> item = {"id": "newId", "data": "someData"};
    await sut.update(id: id, item: {"item": "data"}, table: "/");
    await sut.update(id: id, item: item, table: "/");
    final file = await File(dbfile).readAsString();
    expect(file, contains('newId'));
    expect(file, contains(item['data']));
    expect(file, contains(id));
  });
}
