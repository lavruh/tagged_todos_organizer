import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import './parts_info_repo_test.mocks.dart';
import 'package:path/path.dart' as p;

@GenerateMocks([SembastDbService])
void main() {
  final testDir = Directory(p.normalize("/home/lavruh/tmp/test"));
  final testDirPath = testDir.path;

  test('get part by maximo no', () async {
    final db = MockSembastDbService();
    final ref = ProviderContainer(overrides: [
      appPathProvider.overrideWithValue(testDirPath),
    ]);
    addTearDown(ref.dispose);

    final sut = PartsInfoRepo(db: db, ref: ref as Ref);
    const maximoNo = '6.123.123';
    final resPart = Part(
        maximoNo: maximoNo,
        name: 'name',
        catalogNo: 'catalogNo',
        manufacturer: 'manufacturer',
        bin: 'bin',
        dwg: 'dwg',
        pos: 'pos',
        balance: 'balance');
    when(db.getItemByFieldValue(
            request: captureAnyNamed('request'),
            table: captureAnyNamed('table')))
        .thenAnswer((_) async => resPart.toMap());
    expect(await sut.getPart(maximoNo), resPart);
  });

  test('update parts in db from csv', () async {
    final db = MockSembastDbService();
    final ref = ProviderContainer(overrides: [
      appPathProvider.overrideWithValue(testDirPath),
    ]);
    addTearDown(ref.dispose);

    final sut = PartsInfoRepo(db: db, ref: ref as Ref);
    String maximoNo = '6.121.560';
    Part item = Part(
      maximoNo: maximoNo,
      name: 'Switch,25A,3-Pole with Extended Knob',
      catalogNo: 'OETL 25D1',
      manufacturer: 'MABB',
      bin: '10E124',
      dwg: '',
      pos: '',
      balance: '1',
    );

    when(db.getItemByFieldValue(request: anyNamed('request'), table: 'table'));

    await sut.updatePartsFromCsvString(csvData);

    verify(await db.update(
      id: maximoNo,
      item: {...item.toMap()},
      table: 'parts',
    ))
        .called(1);
  });

  test('import from incorrect file throws exception', () async {
    final db = MockSembastDbService();
    final ref = ProviderContainer(overrides: [
      appPathProvider.overrideWithValue(testDirPath),
    ]);
    addTearDown(ref.dispose);

    final sut = PartsInfoRepo(db: db, ref: ref as Ref);
    String filePath = '';
    expect(() async => await sut.updatePartsFromFile(filePath: filePath),
        throwsException);
  });
}

const csvData =
    '"Item","Description","Catalog #","modelnr. Item","modelnr. vessel","Manufacturer","Default Bin","Assembly drwg","Pos. nr. Assembly drwg","Current Balance","Asset"\r\n"6.121.560","Switch,25A,3-Pole with Extended Knob","OETL 25D1",,,"MABB",10E124,,,1,10069.0003';
