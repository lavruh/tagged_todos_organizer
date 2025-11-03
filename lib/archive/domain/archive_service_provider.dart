import 'package:flutter_riverpod/legacy.dart';
import 'package:tagged_todos_organizer/archive/data/i_archive_service.dart';
import 'package:tagged_todos_organizer/archive/data/local_archive_service.dart';
import 'package:tagged_todos_organizer/utils/app_path_provider.dart';

final archiveServiceProvider = StateProvider<IArchiveService>((ref) {
  final service = LocalArchiveService();
  final path = ref.watch(appPathProvider);
  service.init(rootPath: path);
  return service;
});
