import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/attachemets_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class TodoEditScreen extends ConsumerWidget {
  const TodoEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(val.msg ?? ''),
            duration: const Duration(milliseconds: 200)));
      }
    });

    final item = ref.watch(todoEditorProvider);
    if (item == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()));
    }
    final title = TextEditingController(text: item.title);
    final description = TextEditingController(text: item.description);
    return WillPopScope(
      onWillPop: () async => _goToTodosScreen(context),
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
                onPressed: () {
                  ref.read(todosProvider.notifier).deleteTodo(todo: item);
                  _goToTodosScreen(context);
                },
                icon: const Icon(Icons.delete)),
            IconButton(
              onPressed: () {
                assert(item != null);
                ref.read(todoEditorProvider.notifier).updateTodo(item);
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
                    child: TextFormField(
                      controller: title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      onFieldSubmitted: (value) {
                        ref
                            .read(todoEditorProvider.notifier)
                            .setTodo(item.copyWith(title: value));
                      },
                    ),
                  ),
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
                      child: TextFormField(
                        controller: description,
                        maxLines: 3,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onFieldSubmitted: (value) {
                          ref
                              .read(todoEditorProvider.notifier)
                              .setTodo(item.copyWith(description: value));
                        },
                      ),
                    ),
                  ],
                ),
                TagsWidget(
                  tags: item.tags,
                  updateTags: (t) => ref
                      .read(todoEditorProvider.notifier)
                      .setTodo(item.copyWith(tags: t)),
                ),
                const AttachementsPreviewWidget(),
                SubTodosOverviewWidget(parentId: item.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _goToTodosScreen(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    return true;
  }
}
