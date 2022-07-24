import 'dart:convert';

class UniqueId {
  final String id;
  UniqueId({String? id}) : id = id ?? generate();

  static String generate() => DateTime.now().millisecondsSinceEpoch.toString();

  String toMap() {
    return id;
  }

  factory UniqueId.fromMap(String? map) {
    return UniqueId(
      id: map ?? generate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UniqueId.fromJson(String source) =>
      UniqueId.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UniqueId && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => id;
}
