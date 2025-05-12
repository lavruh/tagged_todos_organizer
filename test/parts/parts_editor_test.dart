import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_editor_provider.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/parts/domain/used_part.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import './parts_editor_test.mocks.dart';

class Listener extends Mock {
  void call(List<UsedPart>? previous, List<UsedPart> value);
}

class TodoEditorListener extends Mock {
  void call(ToDo? previous, ToDo? value);
}

@GenerateMocks([PartsInfoRepo])
void main() {
  final testDir = Directory(p.normalize("/home/lavruh/tmp/test"));
  final testDirPath = testDir.path;
  tearDown(() {
    for (final i in testDir.listSync()) {
      i.deleteSync(recursive: true);
    }
  });

  test('add part to parts list', () async {
    final ref = ProviderContainer(
        overrides: [appPathProvider.overrideWithValue(testDirPath)]);
    addTearDown(ref.dispose);
    ref.listen<List<UsedPart>>(partsEditorProvider, Listener().call,
        fireImmediately: true);
    ref.listen<ToDo?>(todoEditorProvider, TodoEditorListener().call,
        fireImmediately: true);
    ref.read(todoEditorProvider.notifier).setTodo(ToDo.empty());
    ref.read(partsEditorProvider.notifier).addPart();
    final part = UsedPart(
        maximoNumber: "maximoNumber", name: "name", bin: "bin", pieces: 1);
    ref.read(partsEditorProvider.notifier).updatePart(part, 0);

    final res = ref.read(partsEditorProvider);
    expect(res, [part]);
    addTearDown(ref.dispose);
  });

  test('delete part from part list', () async {
    final ref = ProviderContainer(
        overrides: [appPathProvider.overrideWithValue(testDirPath)]);
    addTearDown(ref.dispose);
    ref.listen<List<UsedPart>>(partsEditorProvider, Listener().call,
        fireImmediately: true);
    ref.listen<ToDo?>(todoEditorProvider, TodoEditorListener().call,
        fireImmediately: true);
    ref.read(todoEditorProvider.notifier).setTodo(ToDo.empty());
    expect(ref.read(partsEditorProvider).length, 0);
    ref.read(partsEditorProvider.notifier).addPart();
    ref.read(partsEditorProvider.notifier).delete(index: 0);

    expect(ref.read(partsEditorProvider).length, 0);
    addTearDown(ref.dispose);
  });

  test('add part with maximo no', () async {
    const maximoNo = '6.123.123';
    const partName = 'part_name';

    final repo = MockPartsInfoRepo();
    when(repo.getPart(maximoNo)).thenAnswer((_) async => Part(
        maximoNo: maximoNo,
        name: partName,
        catalogNo: 'catalogNo',
        modelNo: 'modelNo',
        modelNoVessel: 'modelNoVessel',
        manufacturer: 'manufacturer',
        bin: '',
        dwg: 'dwg',
        pos: 'pos',
        balance: 'balance'));

    final ref = ProviderContainer(overrides: [
      partsInfoProvider.overrideWithValue(repo),
      appPathProvider.overrideWithValue(testDirPath),
    ]);
    addTearDown(ref.dispose);

    ref.listen<List<UsedPart>>(partsEditorProvider, Listener().call,
        fireImmediately: true);
    ref.listen<ToDo?>(todoEditorProvider, TodoEditorListener().call,
        fireImmediately: true);
    ref.read(todoEditorProvider.notifier).setTodo(ToDo.empty());
    ref.read(partsEditorProvider.notifier).addPart();
    final part = UsedPart.empty().copyWith(maximoNumber: maximoNo);

    await ref
        .read(partsEditorProvider.notifier)
        .updatePartWithMaximoNo(part: part, index: 0);

    expect(ref.read(partsEditorProvider).length, 1);
    expect(ref.read(partsEditorProvider)[0], part.copyWith(name: partName));
  });
}
