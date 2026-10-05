import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;

import 'package:tagged_todos_organizer/parts/domain/part.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_db_provider.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';

final partsInfoProvider = Provider<PartsInfoRepo>((ref) {
  final IDbService? db = ref.watch(tagsDbProvider).value;
  return PartsInfoRepo(db: db, ref: ref);
});

final partsInfoRepoUpdateProgressProvider = StateProvider<double>((ref) => 0);
final partsUpdateLogProvider = StateProvider<List<String>>((ref) => []);

class PartsInfoRepo {
  final IDbService? db;
  final Ref ref;
  final Map<String, int> _fields = {
    "MAXIMO": 0,
    "NAME": 1,
    "CATALOG_NO": 3,
    "MANUFACTURER": 2,
    "BIN": 6,
    "DWG": 20,
    "POS": 21,
    "BALANCE": 7,
  };
  final _table = 'parts';

  PartsInfoRepo({
    required this.db,
    required this.ref,
  });

  void _log(String message) {
    ref
        .read(partsUpdateLogProvider.notifier)
        .update((state) => [...state, message]);
  }

  void _clearLog() {
    ref.read(partsUpdateLogProvider.notifier).state = [];
  }

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

  Future<void> initUpdatePartsFromFile() async {
    _clearLog();
    _log('Select file...');
    final picker = await FilePicker.pickFiles();
    if (picker.isEmpty) {
      _log('No file selected');
      return;
    }
    final selectedFilePath = picker.first.path;
    if (selectedFilePath != null) {
      _log('Selected file: $selectedFilePath');
      try {
        await updatePartsFromFile(filePath: selectedFilePath);
      } on PartsInfoRepoException catch (e) {
        _log('Error: ${e.message}');
        rethrow;
      } catch (e) {
        _log('Error: $e');
        rethrow;
      }
    } else {
      _log('File path is null');
    }
  }

  Future<void> updatePartsFromFile({required String filePath}) async {
    final path = p.normalize(filePath);
    if (p.extension(path) == '.csv') {
      _log('Reading file: $path');
      final file = await File(path).readAsString();
      await updatePartsFromCsvString(file);
    } else {
      final msg = 'File with wrong extension provided (${p.extension(path)})';
      _log('Error: $msg');
      throw PartsInfoRepoException(msg);
    }
  }

  Future<void> updatePartsFromCsvString(String file) async {
    ref.read(partsInfoRepoUpdateProgressProvider.notifier).state = 0;
    _log('Decoding CSV content...');
    final data = const CsvDecoder(
      fieldDelimiter: ';',
      quoteCharacter: '"',
    ).convert(file);
    final totalRows = data.length;
    _log('Found $totalRows rows in CSV');
    if (totalRows < 2) {
      const msg = "Wrong data format: minimum 2 rows required";
      _log('Error: $msg');
      throw PartsInfoRepoException(msg);
    }

    int updatedCount = 0;
    int errorCount = 0;

    for (int i = 0; i < totalRows; i++) {
      if (i == 0) {
        for (int j = 0; j < data[0].length; j++) {
          final key = data[0][j];
          if (_fields.containsKey(key)) {
            _fields[key] = j;
          }
        }
        _log('Header row processed');
      }
      if (i > 0) {
        try {
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
              i / totalRows;
          await db?.update(id: part.maximoNo, item: part.toMap(), table: 'parts');
          updatedCount++;
          _log('Updated part #${part.maximoNo}: ${part.name}');
        } catch (e) {
          errorCount++;
          _log('Error on row $i: $e');
        }
      }
    }
    ref.read(partsInfoRepoUpdateProgressProvider.notifier).state = 1.0;
    _log('Finished updating DB: $updatedCount parts updated, $errorCount errors.');
  }
}

class PartsInfoRepoException implements Exception {
  dynamic message;
  PartsInfoRepoException(this.message);

  @override
  String toString() => ' $message ';
}
