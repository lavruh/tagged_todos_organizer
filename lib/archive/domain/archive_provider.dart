import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/archive/data/i_archive_service.dart';
import 'package:tagged_todos_organizer/archive/data/local_archive_service.dart';
import 'package:tagged_todos_organizer/archive/domain/archive_service_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';

final archiveProvider = Provider<Archive>((ref) {
  final archiveService = ref.watch(archiveServiceProvider);
  final appPath = ref.watch(appPathProvider);
  return Archive(archiveService, appPath: appPath);
});

class Archive {
  final IArchiveService service;
  final String appPath;
  Archive(this.service, {required this.appPath});

  add(ToDo todo) async {
    if (service is LocalArchiveService) {
      try {
        final String path = p.join(appPath, todo.attachDirPath);
        await service.addToArchive(path: path);
      } catch (e) {
        rethrow;
      }
    }
  }
}
