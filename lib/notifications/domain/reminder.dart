import 'package:tagged_todos_organizer/todos/domain/todo.dart';

class Reminder {
  int? id;
  final String sourceTodoId;
  final String title;
  final String message;
  final DateTime time;

  Reminder({
    this.id,
    required this.sourceTodoId,
    required this.title,
    required this.message,
    required this.time,
  });

  factory Reminder.fromToDo(
    ToDo todo, {
    String? message,
    required DateTime time,
  }) {
    return Reminder(
      sourceTodoId: todo.id.toString(),
      title: todo.title,
      message: message ?? todo.description.split("\n").last,
      time: time,
    );
  }

  Reminder copyWith({
    int? id,
    String? sourceTodoId,
    String? title,
    String? message,
    DateTime? time,
  }) {
    return Reminder(
      id: id ?? this.id,
      sourceTodoId: sourceTodoId ?? this.sourceTodoId,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
    );
  }

  @override
  String toString() => "id[$id] - $title - $time";
}
