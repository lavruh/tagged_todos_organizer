import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';

final todoEditorProvider = StateProvider<ToDo?>((ref) => null);
