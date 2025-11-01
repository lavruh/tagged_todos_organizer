import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final partsInfoProvider = Provider<PartsInfoRepo>((ref) {
  final IDbService? db = ref.watch(tagsDbProvider).value;
  return PartsInfoRepo(db: db, ref: ref);
});

final partsInfoRepoUpdateProgressProvider = StateProvider<double>((ref) => 0);

class PartsInfoRepo {
  final IDbService? db;
  final Ref ref;
  final Map<String, int> _fields = {
    "MAXIMO": 0,
    "NAME": 1,
    "CATALOG_NO": 3,
    "MANUFACTURER": 2,
    "BIN": 6,
    "DWG": 16,
    "POS": 17,
    "BALANCE": 7,
  };
  final _table = 'parts';

  PartsInfoRepo({
    required this.db,
    required this.ref,
  });

  Future<Part> getPart(String maximoNo) async {
    final p = await getPartFormDb(req: maximoNo, field: 'maximoNo');
    return p ?? Part.fromMap({'maximoNo': maximoNo});
  }

  Future<Part> getPartByCatalogNo(String catalogNo) async {
    final p = await getPartFormDb(req: catalogNo, field: 'catalogNo');
    return p ?? Part.fromMap({'catalogNo': catalogNo});
  }

  Future<Part?> getPartFormDb({
    required String req,
    required String field,
  }) async {
    final map =
        await db?.getItemByFieldValue(request: {field: req}, table: _table);
    if (map != null && map.isNotEmpty) {
      return Part.fromMap(map);
    }
    return null;
  }

  initUpdatePartsFromFile() async {
    final picker = await FilePicker.platform.pickFiles();
    if (picker != null && picker.paths.first != null) {
      final filePath = picker.paths.first!;
      try {
        await updatePartsFromFile(filePath: filePath);
      } on PartsInfoRepoException {
        rethrow;
      }
    }
  }

  updatePartsFromFile({required String filePath}) async {
    final path = p.normalize(filePath);
    if (p.extension(path) == '.csv') {
      final file = await File(path).readAsString();
      await updatePartsFromCsvString(file);
    } else {
      throw PartsInfoRepoException('File with wrong extention provided');
    }
  }

  Future<void> updatePartsFromCsvString(String file) async {
    ref.read(partsInfoRepoUpdateProgressProvider.notifier).state = 0;
    final data = const CsvToListConverter().convert(
      file,
      fieldDelimiter: ';',
      textDelimiter: '"',
      shouldParseNumbers: false,
    );
    final totalRows = data.length;
    if (totalRows < 2) throw PartsInfoRepoException("Wrong data format");
    for (int i = 0; i < totalRows; i++) {
      if (i == 0) {
        for (int j = 0; j < data[0].length; j++) {
          final key = data[0][j];
          if (_fields.containsKey(key)) {
            _fields[key] = j;
          }
        }
      }
      if (i > 0) {
        final map = data[i];
        final part = Part(
            maximoNo: map[_fields["MAXIMO"]!],
            name: map[_fields["NAME"]!],
            catalogNo: map[_fields["CATALOG_NO"]!],
            manufacturer: map[_fields["MANUFACTURER"]!],
            bin: map[_fields["BIN"]!],
            dwg: map[_fields["DWG"]!],
            pos: map[_fields["POS"]!],
            balance: map[_fields["BALANCE"]!]);
        ref.read(partsInfoRepoUpdateProgressProvider.notifier).state =
            i * 100 / totalRows;
        await db?.update(id: part.maximoNo, item: part.toMap(), table: 'parts');
      }
    }
  }
}

class PartsInfoRepoException implements Exception {
  dynamic message;
  PartsInfoRepoException(this.message);

  @override
  String toString() => ' $message ';
}
