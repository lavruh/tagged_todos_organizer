import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/archive/data/i_archive_service.dart';

class LocalArchiveService implements IArchiveService {
  late final String archivePath;
  late final Directory todosRoot;

  @override
  Future<void> addToArchive({required String path}) async {
    final inp = Directory(path);
    final inpName = p.basenameWithoutExtension(path);
    if (!inp.existsSync()) {
      throw Exception('Wrong source <$path> does not exist');
    }
    final zip = ZipFileEncoder();
    await zip.zipDirectory(inp, filename: p.join(archivePath, '$inpName.zip'));
  }

  @override
  Future<void> extractFromArchive({required String path}) async {
    final name = p.basenameWithoutExtension(path);
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('Wrong source <$path> does not exist');
    }

    final zip = ZipDecoder().decodeBytes(file.readAsBytesSync());
    for (final file in zip) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(p.join(todosRoot.path, name, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(p.join(todosRoot.path, name, filename))
            .createSync(recursive: true);
      }
    }
  }

  @override
  Future<void> init({required String rootPath}) async {
    final dir = Directory(rootPath);
    if (dir.existsSync()) {
      archivePath = p.join(rootPath, 'archive');
      final arch = Directory(archivePath);
      if (!arch.existsSync()) arch.createSync(recursive: true);
      todosRoot = Directory(p.join(rootPath, 'todos'));
      if (!todosRoot.existsSync()) {
        throw Exception('Wrong todos path provided ${todosRoot.path}');
      }
    }
  }

  @override
  Future<void> removeFromArchive({required String path}) async {
    final zip = File(path);
    if (!zip.existsSync()) throw Exception('File $path does not exist');
    zip.delete(recursive: true);
  }
}
