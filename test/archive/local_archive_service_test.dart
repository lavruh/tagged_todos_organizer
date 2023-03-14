import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/archive/data/i_archive_service.dart';
import 'package:tagged_todos_organizer/archive/data/local_archive_service.dart';

const path = '/home/lavruh/tmp/test';

main() {
  tearDown(() {
    final dir = Directory(path);
    for (final f in dir.listSync()) {
      f.deleteSync(recursive: true);
    }
  });

  test('init service', () async {
    final IArchiveService sut = LocalArchiveService();
    expect(() => LocalArchiveService().init(rootPath: path), throwsException);
    Directory(p.join(path, 'todos')).createSync();
    await sut.init(rootPath: path);
    await pumpEventQueue(times: 20);
    expect(Directory(p.join(path, 'archive')).existsSync(), true);
    expect(Directory(p.join(path, 'todos')).existsSync(), true);
  });

  test('archive todo  with sub todo', () async {
    final todoPath = p.join(path, 'todos', 'todo1');
    await _arrangeData(todoPath);
    final IArchiveService sut = LocalArchiveService();
    final arch = Directory(p.join(path, 'archive'));
    await sut.init(rootPath: path);
    await sut.addToArchive(path: todoPath);
    final archName = '${p.basename(todoPath)}.zip';
    expect(
        arch.listSync().any((e) {
          return p.basename(e.path) == archName;
        }),
        true);

    await pumpEventQueue(times: 20);
    final archivedFilePath =
        p.join(path, 'archive', '${p.basename(todoPath)}.zip');
    final zip = ZipDecoder().decodeBuffer(InputFileStream(archivedFilePath));
    expect(zip.files.length, 3);
    await pumpEventQueue(times: 20);
  });

  test('extract data from archive', () async {
    final todoPath = p.join(path, 'todos', 'todo1');
    await _arrangeData(todoPath);
    final IArchiveService sut = LocalArchiveService();
    final arch = Directory(p.join(path, 'archive'));
    final archName = '${p.basename(todoPath)}.zip';
    await sut.init(rootPath: path);
    await sut.addToArchive(path: todoPath);
    Directory(todoPath).deleteSync(recursive: true);
    expect(Directory(p.join(path, 'todos')).listSync().length, 0);
    await sut.extractFromArchive(path: p.join(arch.path, archName));
    expect(Directory(p.join(path, 'todos')).listSync().length, 1);
    expect(Directory(todoPath).listSync().length, 2);
    expect(Directory(p.join(todoPath, 'subtodo')).listSync().length, 1);
    await pumpEventQueue(times: 20);
  });

  test('remove from archive', () async {
    const archName = 'todo1.zip';
    final archPath = p.join(path, 'archive', archName);
    File(archPath).createSync(recursive: true);
    Directory(p.join(path, 'todos')).createSync();
    final IArchiveService sut = LocalArchiveService();
    await sut.init(rootPath: path);

    await sut.removeFromArchive(path: archPath);

    expect(Directory(p.join(path, 'archive')).listSync().length, 0);
  });
}

_arrangeData(String todoPath) async {
  final item = Directory(todoPath);
  await item.create(recursive: true);
  await File(p.join(todoPath, 'data.json')).writeAsString('contents');
  final subPath = p.join(item.path, 'subtodo');
  Directory(subPath).createSync(recursive: true);
  await File(p.join(subPath, 'data.json')).writeAsString('contents');
}
