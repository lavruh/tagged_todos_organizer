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
  return PartsInfoRepo(db: db);
});

class PartsInfoRepo {
  final IDbService? db;

  PartsInfoRepo({
    required this.db,
  });

  Future<Part> getPart(String maximoNo) async {
    final map = await db?.getItemByFieldValue(
      request: {'maximoNo': maximoNo},
      table: 'parts',
    );
    if(map!= null && map.isNotEmpty){
      return Part.fromMap(map);
    }
    return Part.fromMap({'maximoNo': maximoNo});
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
    final data = const CsvToListConverter().convert(
      file,
      fieldDelimiter: ',',
      textDelimiter: '"',
      shouldParseNumbers: false,
    );
    for (int i = 0; i < data.length; i++) {
      if (i == 0) {
        if (data[0][0] != 'Item' ||
            data[0][1] != 'Description' ||
            data[0][2] != 'Catalog #' ||
            data[0][3] != 'modelnr. Item' ||
            data[0][4] != 'modelnr. vessel' ||
            data[0][5] != 'Manufacturer' ||
            data[0][6] != 'Default Bin' ||
            data[0][7] != 'Assembly drwg' ||
            data[0][8] != 'Pos. nr. Assembly drwg' ||
            data[0][9] != 'Current Balance' ||
            data[0][10] != 'Asset') {
          throw PartsInfoRepoException('Wrong file supplied');
        }
      }
      if (i > 0) {
        final part = Part(
            maximoNo: data[i][0],
            name: data[i][1],
            catalogNo: data[i][2],
            modelNo: data[i][3],
            modelNoVessel: data[i][4],
            manufacturer: data[i][5],
            bin: data[i][6],
            dwg: data[i][7],
            pos: data[i][8],
            balance: data[i][9]);
        await db?.update(
            id: part.maximoNo, item: part.toMap(), table: 'parts');
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
