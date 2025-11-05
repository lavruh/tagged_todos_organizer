import 'dart:convert';

import 'package:tagged_todos_organizer/parts/domain/part.dart';

class UsedPart {
  final String maximoNumber;
  final String catalogNo;
  final String name;
  final String bin;
  final int pieces;

  UsedPart({
    required this.maximoNumber,
    required this.catalogNo,
    required this.name,
    required this.bin,
    required this.pieces,
  });

  UsedPart.fromPart({required Part part, int qty = 0})
      : maximoNumber = part.maximoNo,
        catalogNo = part.catalogNo,
        name = part.name,
        bin = part.bin,
        pieces = qty;

  UsedPart.empty({
    this.maximoNumber = '',
    this.catalogNo = '',
    this.name = '',
    this.bin = '',
    this.pieces = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'maximoNumber': maximoNumber,
      'catalogNo': catalogNo,
      'name': name,
      'bin': bin,
      'pieces': pieces,
    };
  }

  factory UsedPart.fromMap(Map<String, dynamic> map) {
    return UsedPart(
      maximoNumber: map['maximoNumber'] ?? '',
      catalogNo: map['catalogNo'] ?? '',
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
    String? catalogNo,
    String? name,
    String? bin,
    int? pieces,
  }) {
    return UsedPart(
      maximoNumber: maximoNumber ?? this.maximoNumber,
      catalogNo: catalogNo ?? this.catalogNo,
      name: name ?? this.name,
      bin: bin ?? this.bin,
      pieces: pieces ?? this.pieces,
    );
  }

  @override
  String toString() {
    return 'UsedPart(maximoNumber: $maximoNumber, name: $name, bin: $bin, pieces: $pieces)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsedPart &&
        other.maximoNumber == maximoNumber &&
        other.catalogNo == catalogNo &&
        other.name == name &&
        other.bin == bin &&
        other.pieces == pieces;
  }

  @override
  int get hashCode {
    return maximoNumber.hashCode ^
        catalogNo.hashCode ^
        name.hashCode ^
        bin.hashCode ^
        pieces.hashCode;
  }
}
