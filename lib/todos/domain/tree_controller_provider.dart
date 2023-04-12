import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/sub_todos_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';

final treeControllerProvider = Provider((ref) => TreeController<ToDo>(
    roots: ref.watch(filteredTodosProvider),
    childrenProvider: (todo) =>
        ref.read(subTodosProvider(todo.id)) ?? const Iterable.empty()));
