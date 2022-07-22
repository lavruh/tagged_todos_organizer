abstract class ITagsDbService {
  Future<void> addTag({required Map<String, dynamic> item});
  Future<void> updateTag(
      {required String id, required Map<String, dynamic> item});
  Future<void> deleteTag({required String id});
  Stream<Map<String, dynamic>> getTags();
}
