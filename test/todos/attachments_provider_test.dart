import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/utils/unique_id.dart';


main() async {
  final testDir = Directory(p.normalize("/home/lavruh/tmp/test"));
  final testDirPath = testDir.path;
  tearDown(() {
    for (final i in testDir.listSync()) {
      i.deleteSync(recursive: true);
    }
  });

  test('create attachment folder for new todo', () async {
    final ref = ProviderContainer(
        overrides: [appPathProvider.overrideWithValue(testDirPath)]);
    addTearDown(ref.dispose);
    ref.listen<List<String>>(attachmentsProvider, (_, __) {},
        fireImmediately: true);
    final sut = ref.read(attachmentsProvider.notifier);
    final todo = ToDo.empty();

    final res = sut.manage(
      id: todo.id.toString(),
      attachmentsDirPath: todo.attachDirPath,
      parentId: todo.parentId?.id,
      createDir: true,
    );

    await pumpEventQueue(times: 20);

    expect(ref.read(attachmentsProvider), []);
    final attachmentsPath = p.join(testDirPath, 'todos', todo.id.id);
    expect(sut.path, attachmentsPath);
    expect(Directory(attachmentsPath).existsSync(), true);
    expect(res, attachmentsPath);
  });

  test('find attachment folder for todo with wrong path', () async {
    final ref = ProviderContainer(
        overrides: [appPathProvider.overrideWithValue(testDirPath)]);
    addTearDown(ref.dispose);
    ref.listen<List<String>>(attachmentsProvider, (_, __) {},
        fireImmediately: true);
    final sut = ref.read(attachmentsProvider.notifier);
    const id = '1';
    final todo = ToDo.empty().copyWith(
        id: UniqueId(id: id), attachDirPath: p.join(testDirPath, 'todos', id));
    final attachmentsPath =
        p.join(testDirPath, 'todos', 'someParent', todo.id.id);
    Directory(attachmentsPath).createSync(recursive: true);

    final res = sut.manage(
        id: todo.id.toString(),
        attachmentsDirPath: todo.attachDirPath,
        parentId: todo.parentId?.id);

    await pumpEventQueue(times: 20);

    expect(ref.read(attachmentsProvider), []);
    expect(sut.path, attachmentsPath);
    expect(res, attachmentsPath);
  });
}
