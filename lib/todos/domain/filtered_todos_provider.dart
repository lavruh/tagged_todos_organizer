import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filters_by_tags_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/domain/datetime_extension.dart';

final filteredTodosProvider = Provider<List<ToDo>>((ref) {
  final allTodos = ref.watch(todosProvider);
  final filter = ref.watch(todosFilter);
  final filterByTags = ref.watch(filterByTagsProvider);
  final filterByDate = ref.watch(todosFilterByDate);
  List<ToDo> filteredTodos = allTodos;
  if (ref.watch(todosFilterShowUnDone)) {
    filteredTodos =
        filteredTodos.where((element) => element.done == false).toList();
  }
  if (filter.isEmpty) {
    filteredTodos =
        filteredTodos.where((element) => element.parentId == null).toList();
  }
  if (filterByDate != null) {
    // Modify to date range
    filteredTodos = filteredTodos
        .where((todo) =>
            todo.date != null &&
            todo.date!.millisecondsSinceEpoch >=
                filterByDate.start.millisecondsSinceEpoch &&
            todo.date!.millisecondsSinceEpoch <=
                filterByDate.end.millisecondsSinceEpoch)
        .toList();
  }
  if (filterByTags.isNotEmpty) {
    filteredTodos = filteredTodos.where((todo) {
      return filterByTags.every((element) => todo.tags.contains(element));
    }).toList();
  }
  filteredTodos =
      filteredTodos.where((todo) => todo.title.contains(filter)).toList();
  List<ToDo> withDates = [];
  List<ToDo> withNoDates = [];
  for (final item in filteredTodos) {
    if (item.date == null) {
      withNoDates.add(item);
    } else {
      if (!ref.watch(todosFilterShowFutureDates)) {
        final now = DateTime.now();
        final today =
            now.copyWith(hour: 23, minute: 59, second: 59, millisecond: 0);
        if (item.date!.millisecondsSinceEpoch <= today.millisecondsSinceEpoch) {
          withDates.add(item);
        }
      } else {
        withDates.add(item);
      }
    }
  }

  withDates.sort((a, b) {
    final tmp = b.date!.compareDateTo(a.date!);
    final aDate = a.date;
    final bDate = b.date;
    if (aDate != null && bDate != null) {
      if (aDate.year == bDate.year &&
          aDate.month == bDate.month &&
          aDate.day == bDate.day) {
        return a.priority.compareTo(b.priority);
      }
    }
    return tmp;
  });
  return [...withDates, ...withNoDates];
});

final todosFilter = StateProvider<String>((ref) => '');
final todosFilterByDate = StateProvider<DateTimeRange?>((ref) => null);
final todosFilterShowAll = StateProvider<bool>((ref) => false);
final todosFilterShowUnDone = StateProvider<bool>((ref) => true);
final todosFilterShowFutureDates = StateProvider<bool>((ref) => false);
