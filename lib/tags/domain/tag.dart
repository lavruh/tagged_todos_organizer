import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class Tag {
  final UniqueId id;
  final String name;
  final int color;
  final String group;
  Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.group,
  });
  Tag.empty()
      : id = UniqueId(),
        name = "",
        color = Colors.grey.value,
        group = "";
  Tag.withName(String n)
      : id = UniqueId(),
        name = n,
        color = Colors.grey.value,
        group = "";
  Tag copyWith({
    UniqueId? id,
    String? name,
    int? color,
    String? group,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      group: group ?? this.group,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        other.group == group;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ color.hashCode ^ group.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toMap(),
      'name': name,
      'color': color,
      'group': group,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: UniqueId.fromMap(map['id']),
      name: map['name'] ?? '',
      color: map['color'] ?? 0,
      group: map['group'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));
}
