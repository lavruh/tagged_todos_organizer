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
      'id': id,
      'title': title,
      'date': date,
      'tags': tags,
      'relatedId': relatedId,
      'action': action,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'] as UniqueId,
      title: map['title'] as String,
      date: map['date'] as DateTime,
      tags: map['tags'] as List<UniqueId>,
      relatedId: map['relatedId'],
      action: map['action'] as LoggableAction,
    );
  }

  @override
  String toString() {
    return 'LogEntry{title: $title, date: $date, action: $action}';
  }
}
