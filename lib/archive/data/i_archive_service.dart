abstract class IArchiveService {
  Future<void> init({required String rootPath});
  Future<void> addToArchive({required String path});
  Future<void> removeFromArchive({required String path});
  Future<void> extractFromArchive({required String path});
}
