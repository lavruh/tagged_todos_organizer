import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_parts_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/attachemets_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class TodoEditScreen extends ConsumerWidget {
  const TodoEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(val.msg ?? ''),
            duration: const Duration(milliseconds: 3000)));
      }
    });

    final item = ref.watch(todoEditorProvider);
    if (item == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()));
    }
    return WillPopScope(
      onWillPop: () async => _goToTodosScreen(GoRouter.of(context)),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (item.parentId != null)
              TextButton(
                  onPressed: () {
                    if (item.parentId != null) {
                      ref
                          .read(todoEditorProvider.notifier)
                          .setById(item.parentId!);
                    }
                  },
                  child: const Text('Go parent',
                      style: TextStyle(color: Colors.white))),
            IconButton(
                onPressed: () async {
                  final navigator = GoRouter.of(context);
                  final bool act = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Delete todo?'),
                            actions: [
                              IconButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  icon: const Icon(Icons.check)),
                              IconButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  icon: const Icon(Icons.cancel)),
                            ],
                          ));
                  if (act) {
                    ref.read(todosProvider.notifier).deleteTodo(todo: item);
                    navigator.go('/');
                    // _goToTodosScreen(navigator);
                  }
                },
                icon: const Icon(Icons.delete)),
            IconButton(
              onPressed: () async {
                await ref.read(todoEditorProvider.notifier).updateTodo(item);
              },
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: ListView(
              children: [
                Row(children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Checkbox(
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(todoEditorProvider.notifier)
                              .setTodo(item.copyWith(done: value));
                        }
                      },
                      value: item.done,
                    ),
                  ),
                  Flexible(
                      child: TextFieldWithConfirm(
                          key: Key(item.title),
                          text: item.title,
                          lable: 'Title',
                          onConfirm: (value) => ref
                              .read(todoEditorProvider.notifier)
                              .setTodo(item.copyWith(title: value)))),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: TextButton(
                          onPressed: () async {
                            final date = await showDialog<DateTime>(
                                context: context,
                                builder: (context) => DatePickerDialog(
                                    initialDate: item.date ?? DateTime.now(),
                                    firstDate:
                                        DateTime(DateTime.now().year - 1),
                                    lastDate:
                                        DateTime(DateTime.now().year + 3)));
                            if (date != null) {
                              ref
                                  .read(todoEditorProvider.notifier)
                                  .setTodo(item.copyWith(date: date));
                            }
                          },
                          child: item.date == null
                              ? const Icon(Icons.calendar_month)
                              : Text(
                                  DateFormat('y\nMM-dd').format(item.date!),
                                )),
                    ),
                    Flexible(
                      child: TextFieldWithConfirm(
                        key: Key(item.description),
                        text: item.description,
                        onConfirm: (value) {
                          ref
                              .read(todoEditorProvider.notifier)
                              .setTodo(item.copyWith(description: value));
                        },
                        lable: 'Description',
                      ),
                    ),
                  ],
                ),
                TagsWidget(
                  key: Key(item.tags.hashCode.toString()),
                  tags: item.tags,
                  updateTags: (t) => ref
                      .read(todoEditorProvider.notifier)
                      .setTodo(item.copyWith(tags: t)),
                ),
                const AttachementsPreviewWidget(),
                UsedPartsWidget(
                  update: (usedParts) {
                    ref
                        .read(todoEditorProvider.notifier)
                        .setTodo(item.copyWith(usedParts: usedParts));
                  },
                ),
                SubTodosOverviewWidget(parent: item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _goToTodosScreen(GoRouter router) {
    return true;
  }
}
