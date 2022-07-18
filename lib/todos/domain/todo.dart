import 'dart:convert';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class ToDo {
  final UniqueId id;
  final String title;
  final String description;
  final bool done;
  final UniqueId? parentId;
  final List<UniqueId> children;
  final List<String> attacments;
  final List tags;
  ToDo({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.parentId,
    required this.children,
    required this.attacments,
    required this.tags,
  });

  ToDo.empty()
      : id = UniqueId(),
        title = '',
        description = '',
        done = false,
        parentId = null,
        children = [],
        attacments = [],
        tags = [];

  ToDo copyWith({
    UniqueId? id,
    String? title,
    String? description,
    bool? done,
    UniqueId? parentId,
    List<UniqueId>? children,
    List<String>? attacments,
    List? tags,
  }) {
    return ToDo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        done: done ?? this.done,
        parentId: parentId ?? this.parentId,
        children: children ?? this.children,
        attacments: attacments ?? this.attacments,
        tags: tags ?? this.tags);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toMap(),
      'title': title,
      'description': description,
      'done': done,
      'parentId': parentId?.toMap(),
      'children': children.map((x) => x.toMap()).toList(),
      'attacments': attacments,
      'tags': tags,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: UniqueId.fromMap(map['id']),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      done: map['done'] ?? false,
      parentId:
          map['parentId'] != null ? UniqueId.fromMap(map['parentId']) : null,
      children: List<UniqueId>.from(
          map['children']?.map((x) => UniqueId.fromMap(x)) ?? const []),
      attacments: List<String>.from(map['attacments'] ?? const []),
      tags: List.from(map['tags'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDo.fromJson(String source) => ToDo.fromMap(json.decode(source));
}
