import 'dart:convert';

class UsedPart {
  final String maximoNumber;
  final String name;
  final String bin;
  final int pieces;

  UsedPart({
    required this.maximoNumber,
    required this.name,
    required this.bin,
    required this.pieces,
  });

  UsedPart.empty({
    this.maximoNumber = '',
    this.name = '',
    this.bin = '',
    this.pieces = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'maximoNumber': maximoNumber,
      'name': name,
      'bin': bin,
      'pieces': pieces,
    };
  }

  factory UsedPart.fromMap(Map<String, dynamic> map) {
    return UsedPart(
      maximoNumber: map['maximoNumber'] ?? '',
      name: map['name'] ?? '',
      bin: map['bin'] ?? '',
      pieces: map['pieces'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsedPart.fromJson(String source) =>
      UsedPart.fromMap(json.decode(source));

  UsedPart copyWith({
    String? maximoNumber,
    String? name,
    String? bin,
    int? pieces,
  }) {
    return UsedPart(
      maximoNumber: maximoNumber ?? this.maximoNumber,
      name: name ?? this.name,
      bin: bin ?? this.bin,
      pieces: pieces ?? this.pieces,
    );
  }
}
