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
}
