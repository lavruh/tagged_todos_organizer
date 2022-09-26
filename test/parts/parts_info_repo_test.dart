import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/parts/domain/parts_info_repo.dart';
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart';
import './parts_info_repo_test.mocks.dart';

@GenerateMocks([SembastDbService])
void main() {
  test('get part by maximo no', () async {
    final db = MockSembastDbService();
    final sut = PartsInfoRepo(db: db);
    const maximoNo = '6.123.123';
    final resPart = Part(
        maximoNo: maximoNo,
        name: 'name',
        catalogNo: 'catalogNo',
        modelNo: 'modelNo',
        modelNoVessel: 'modelNoVessel',
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
    final sut = PartsInfoRepo(db: db);
    String maximoNo = '6.121.560';
    Part item = Part(
      maximoNo: maximoNo,
      name: 'Switch,25A,3-Pole with Extended Knob',
      catalogNo: 'OETL 25D1',
      modelNo: '',
      modelNoVessel: '',
      manufacturer: 'MABB',
      bin: '10E124',
      dwg: '',
      pos: '',
      balance: '1',
    );
    String filePath =
        '/home/lavruh/Documents/TaggedTodosOrganizer/parts/bin_utf8.csv';
    when(db.getItemByFieldValue());

    await sut.updatePartsFromFile(filePath: filePath);

    verify(await db.update(
      id: maximoNo,
      item: {...item.toMap()},
      table: 'parts',
    ))
        .called(1);
  });

  test('import from incorrect file throws exception', () async {
    final db = MockSembastDbService();
    final sut = PartsInfoRepo(db: db);
    String filePath = '';
    expect(() async => await sut.updatePartsFromFile(filePath: filePath),
        throwsException);
  });
}
