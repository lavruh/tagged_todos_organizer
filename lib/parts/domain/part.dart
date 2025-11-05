import 'dart:convert';

class Part {
  final String maximoNo;
  final String name;
  final String catalogNo;
  final String manufacturer;
  final String bin;
  final String dwg;
  final String pos;
  final String balance;

  Part({
    required this.maximoNo,
    required this.name,
    required this.catalogNo,
    required this.manufacturer,
    required this.bin,
    required this.dwg,
    required this.pos,
    required this.balance,
  });

  Part copyWith({
    String? maximoNo,
    String? name,
    String? catalogNo,
    String? manufacturer,
    String? bin,
    String? dwg,
    String? pos,
    String? balance,
  }) {
    return Part(
      maximoNo: maximoNo ?? this.maximoNo,
      name: name ?? this.name,
      catalogNo: catalogNo ?? this.catalogNo,
      manufacturer: manufacturer ?? this.manufacturer,
      bin: bin ?? this.bin,
      dwg: dwg ?? this.dwg,
      pos: pos ?? this.pos,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maximoNo': maximoNo,
      'name': name,
      'catalogNo': catalogNo,
      'manufacturer': manufacturer,
      'bin': bin,
      'dwg': dwg,
      'pos': pos,
      'balance': balance,
    };
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      maximoNo: map['maximoNo'] ?? '',
      name: map['name'] ?? '',
      catalogNo: map['catalogNo'] ?? '',
      manufacturer: map['manufacturer'] ?? '',
      bin: map['bin'] ?? '',
      dwg: map['dwg'] ?? '',
      pos: map['pos'] ?? '',
      balance: map['balance'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Part.fromJson(String source) => Part.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Part &&
        other.maximoNo == maximoNo &&
        other.name == name &&
        other.catalogNo == catalogNo &&
        other.manufacturer == manufacturer &&
        other.bin == bin &&
        other.dwg == dwg &&
        other.pos == pos &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return maximoNo.hashCode ^
        name.hashCode ^
        catalogNo.hashCode ^
        manufacturer.hashCode ^
        bin.hashCode ^
        dwg.hashCode ^
        pos.hashCode ^
        balance.hashCode;
  }

  @override
  String toString() {
    return 'Part(maximoNo: $maximoNo, name: $name, catalogNo: $catalogNo,  manufacturer: $manufacturer, bin: $bin, dwg: $dwg, pos: $pos, balance: $balance)';
  }
}
