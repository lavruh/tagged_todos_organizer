import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagsAlias {
  UniqueId id;
  String title;
  List<UniqueId> tags;

  TagsAlias({UniqueId? id, required this.title, required this.tags})
      : id = id ?? UniqueId();

  TagsAlias.empty()
      : id = UniqueId(),
        title = '',
        tags = [];

  factory TagsAlias.fromMap(Map<String, dynamic> map) {
    return TagsAlias(
      id: UniqueId.fromMap(map['id']),
      title: map['title'],
      tags: List.from(map['tags'].map((e) => UniqueId(id: e)) ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toMap(),
      'title': title,
      'tags': tags.map((e) => e.toMap()).toList(),
    };
  }

  TagsAlias copyWith({UniqueId? id, String? title, List<UniqueId>? tags}) {
    return TagsAlias(
      id: id ?? this.id,
      title: title ?? this.title,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'TagsAlias title: $title \n';
  }
}
