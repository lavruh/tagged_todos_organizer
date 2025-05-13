import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class LogEntry {
  final UniqueId id;
  final String title;
  final DateTime date;
  final List<UniqueId> tags;
  final UniqueId? relatedId;
  final LoggableAction action;

  LogEntry(
      {required this.id,
      required this.title,
      required this.date,
      required this.tags,
      required this.action,
      this.relatedId});

  LogEntry.empty()
      : id = UniqueId(),
        title = '',
        date = DateTime.now(),
        tags = [],
        action = LoggableAction.created,
        relatedId = null;



  LogEntry copyWith({
    UniqueId? id,
    String? title,
    DateTime? date,
    List<UniqueId>? tags,
    UniqueId? relatedId,
    LoggableAction? action,
  }) {
    return LogEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      relatedId: relatedId ?? this.relatedId,
      action: action ?? this.action,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toMap(),
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'tags': tags.map((e) => e.toMap()).toList(),
      'relatedId': relatedId?.toMap(),
      'action': action.index,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntry &&
          runtimeType == other.runtimeType &&
           id == other.id &&
          title == other.title &&
          date.millisecondsSinceEpoch == other.date.millisecondsSinceEpoch &&
          relatedId == other.relatedId &&
          action == other.action;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      tags.hashCode ^
      relatedId.hashCode ^
      action.hashCode;

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: UniqueId.fromMap(map['id']),
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']) ,
      tags: (map['tags'] as List).map((e) => UniqueId.fromMap(e)).toList(),
      relatedId: map['relatedId'] != null ? UniqueId.fromMap(map['relatedId']) : null,
      action: LoggableAction.values[map['action']],
    );
  }

  @override
  String toString() {
    return 'LogEntry id: $id,\n title: $title,\n date: $date,\n tags: $tags,\n relatedId: $relatedId,\n action: $action,\n';
  }
}
