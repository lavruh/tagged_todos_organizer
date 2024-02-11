import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/fs_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';
import 'package:path/path.dart' as p;

const dbPath = '/home/lavruh/tmp/test';
void main() {
  final sut = FsDbService();

  tearDown(() async {
    await sut.clearDb();
  });
  test('init db', () async {
    await sut.init(dbPath: dbPath);
    expect(sut.root, isNotNull);
  });

  test('add todo item to root dir', () async {
    final Map<String, dynamic> item = ToDo(
        id: UniqueId(id: '1'),
        title: 'title',
        description: 'description',
        done: false,
        parentId: null,
        children: [],
        attacments: ['attacments'],
        tags: [UniqueId(id: 't1'), UniqueId(id: 'tag2')],
        attachDirPath: '',
        usedParts: []).toMap();

    await sut.init(dbPath: dbPath);
    await sut.add(item: item, table: '/');

    expect(File(p.join(dbPath, item['id'], 'data.json')).existsSync(), true);
  });

  test('add tag to root dir', () async {
    final id = UniqueId();
    const name = 'name smth';
    final Map<String, dynamic> item =
        Tag(id: id, name: name, color: 0, group: 'group').toMap();
    await sut.init(dbPath: dbPath);
    await sut.add(item: item, table: '/');
    expect(File(p.join(dbPath, '$id', 'data.json')).existsSync(), true);
  });

  test('Clear db', () async {
    const id = 'someId';
    const name = 'folder Name';
    final Map<String, dynamic> item = {'id': id, 'name': name};
    await sut.init(dbPath: dbPath);
    await sut.add(item: item, table: '/');
    expect(File(p.join(dbPath, id, 'data.json')).existsSync(), true);
    await sut.clearDb();
    expect(Directory(dbPath).listSync(), isEmpty);
  });

  test('add todo and sub todos', () async {
    final item = ToDo.empty();
    final sub1 = ToDo.empty().copyWith(title: 'sub1', id: UniqueId(id: 's1'));
    final sub2 = ToDo.empty().copyWith(title: 'sub2', id: UniqueId(id: 's2'));
    await sut.init(dbPath: dbPath);
    await sut.add(item: item.toMap(), table: '/');
    await sut.add(item: sub1.toMap(), table: item.id.id);
    await sut.add(item: sub2.toMap(), table: sub1.id.id);

    expect(
        File(p.join(dbPath, item.id.id, sub1.id.id, sub2.id.id, 'data.json'))
            .existsSync(),
        true);
  });

  test('update item', () async {
    final item = ToDo.empty();
    final sub1 = ToDo.empty().copyWith(title: 'update sub1', parentId: item.id);
    await sut.init(dbPath: dbPath);
    await sut.add(item: item.toMap(), table: '/');
    await sut.add(item: sub1.toMap(), table: item.id.id);

    final update = item.copyWith(title: 'update');
    await sut.update(id: update.id.id, item: update.toMap(), table: '/');
    final result = File(p.join(dbPath, item.id.id, 'data.json'));
    expect(result.existsSync(), true);
    final resultData = sut.fromJson(result.readAsStringSync());
    expect(resultData['id'], item.toMap()['id']);
    expect(resultData['title'], update.toMap()['title']);

    final update2 = sub1.copyWith(title: 'sub update');
    await sut.update(
        id: update2.id.id, item: update2.toMap(), table: update2.parentId!.id);
    final subresult = File(p.join(dbPath, item.id.id, sub1.id.id, 'data.json'));
    expect(subresult.existsSync(), true);
    final subresultData = sut.fromJson(subresult.readAsStringSync());
    expect(subresultData['id'], sub1.toMap()['id']);
    expect(subresultData['title'], update2.toMap()['title']);
  });

  test('get all items', () async {
    final itemTmp = ToDo.empty();

    final String relativePath = p.relative(
        p.join(dbPath, itemTmp.id.toString()),
        from: getAppFolderPath());
    final item = itemTmp.copyWith(attachDirPath: relativePath);

    final sub1 = ToDo.empty().copyWith(title: 'sub1');
    final sub2 = ToDo.empty().copyWith(title: 'sub2');
    await sut.init(dbPath: dbPath);
    await sut.add(item: item.toMap(), table: '/');
    await sut.add(item: sub1.toMap(), table: item.id.id);
    await sut.add(item: sub2.toMap(), table: sub1.id.id);

    final result = sut.getAll(table: '/');
    expect(result, emitsInAnyOrder([item.toMap()]));
  });

  test('delete item', () async {
    final item = ToDo.empty();
    final sub1 = ToDo.empty().copyWith(title: 'sub1');
    final sub2 = sub1.copyWith(id: UniqueId(id: 's2'));
    await sut.init(dbPath: dbPath);
    await sut.add(item: item.toMap(), table: '/');
    await sut.add(item: sub1.toMap(), table: item.id.id);
    await sut.add(item: sub2.toMap(), table: '/');
    await sut.delete(id: item.id.id, table: '/');
    expect(sut.getAll(table: '/'), neverEmits(sub1.toMap()));
    await sut.delete(id: sub2.id.id, table: '/');
    expect(sut.getAll(table: '/'), emitsDone);
  });

  test('add files in dir as attachements', () async {
    final item = ToDo.empty();
    final sub1 = ToDo.empty().copyWith(title: 'sub1');
    await sut.init(dbPath: dbPath);
    await sut.add(item: item.toMap(), table: '/');
    await sut.add(item: sub1.toMap(), table: item.id.id);
    File(p.join(dbPath, item.id.id, 'attch.txt')).createSync();
    File(p.join(dbPath, item.id.id, 'attch.pdf')).createSync();

    List<Map<String, dynamic>> data = [];
    await for (final i in sut.getAll(table: '/')) {
      data.add(i);
    }
    expect(data[0]['attacments'].length, 2);
  });

  test('get item by field value', () async {
    await sut.init(dbPath: dbPath);
    final testData = {
      'id': '6.123.123',
      'maximoNo': '6.123.123',
      'name:': 'kasldkjalskd'
    };
    final testData2 = {
      'id': '6.123.132',
      'maximoNo': '6.123.132',
      'name:': 'kasldkjalskd'
    };
    await sut.update(id: 'parts', item: {'id': 'parts'}, table: '/');
    await sut.add(item: testData, table: 'parts');
    await sut.add(item: testData2, table: 'parts');

    final result = await sut.getItemByFieldValue(
      request: {'maximoNo': '6.123.123'},
      table: 'parts',
    );
    expect(result, testData);
  });

  test('update method should change ID if it does not equal item["id"]',
      () async {
    final item = ToDo.empty();
    await sut.init(dbPath: dbPath);
    await sut.add(item: item.toMap(), table: '/');

    final update = item.copyWith(title: 'update', id: UniqueId(id: 'newId'));
    await sut.update(id: item.id.id, item: update.toMap(), table: '/');
    final result = File(p.join(dbPath, update.id.id, 'data.json'));
    expect(result.existsSync(), true);
    final resultData = sut.fromJson(result.readAsStringSync());
    expect(resultData['id'], update.toMap()['id']);
    expect(resultData['title'], update.toMap()['title']);
  });
}
