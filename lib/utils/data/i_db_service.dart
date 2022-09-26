abstract class IDbService {
  Future<void> init({required String dbPath});
  Future<void> add({
    required Map<String, dynamic> item,
    required String table,
  });
  Future<void> update({
    required String id,
    required Map<String, dynamic> item,
    required String table,
  });
  Future<void> delete({
    required String id,
    required String table,
  });
  Stream<Map<String, dynamic>> getAll({
    required String table,
  });
  Future<void> deleteTable({required String table});

  Future<Map<String, dynamic>> getItemByFieldValue({
    required Map<String, String> request,
    required String table,
  });
}
