abstract class IDbService {
  Future<void> init({required String table, required String dbPath});
  Future<void> add({required Map<String, dynamic> item});
  Future<void> update({required String id, required Map<String, dynamic> item});
  Future<void> delete({required String id});
  Stream<Map<String, dynamic>> getAll();
}
