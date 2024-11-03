import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:tagged_todos_organizer/parts/presentation/used_parts_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/screens/todo_select_screen.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/attachemets_preview_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/priority_slider_widget.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/sub_todos_overview_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/confirm_dialog.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_confirm.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TodoEditScreen extends ConsumerWidget {
  const TodoEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(todoEditorProvider);
    final notifier = ref.read(todoEditorProvider.notifier);
    if (item == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()));
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (fl) async {
        if (fl) return;
        return notifier.checkIfToSave(GoRouter.of(context), context);
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (item.parentId != null)
              TextButton(
                  onPressed: () {
                    if (item.parentId != null) {
                      notifier.setById(item.parentId!);
                    }
                  },
                  child: const Text('Go parent',
                      style: TextStyle(color: Colors.white))),
            IconButton(
                onPressed: () async {
                  final newPath = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TodoSelectScreen()));
                  try {
                    if (newPath == '/') {
                      notifier.changeTodoParent(null);
                    } else if (newPath != null &&
                        newPath.runtimeType == UniqueId) {
                      notifier.changeTodoParent(newPath);
                    }
                  } on Exception catch (e) {
                    ref.read(snackbarProvider).show(e.toString());
                  }
                },
                icon: const Icon(Icons.move_up)),
            IconButton(
                onPressed: () async {
                  final navigator = GoRouter.of(context);
                  final act =
                      await confirmDialog(context, title: "Archive todo?");
                  if (act == true &&
                      await ref
                          .read(todosProvider.notifier)
                          .archiveTodo(todo: item)) {
                    navigator.go('/');
                  }
                },
                icon: const Icon(Icons.archive)),
            IconButton(
                onPressed: () async {
                  final navigator = GoRouter.of(context);
                  final act =
                      await confirmDialog(context, title: 'Delete todo?');
                  if (act == true) {
                    ref.read(todosProvider.notifier).deleteTodo(todo: item);
                    navigator.go('/');
                  }
                },
                icon: const Icon(Icons.delete)),
            IconButton(
              onPressed: () async {
                await notifier.updateTodo(item);
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
                      key: const Key('checkbox_done'),
                      onChanged: (value) {
                        if (value != null) {
                          notifier.changeState(item.copyWith(done: value));
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
                          onConfirm: (value) {
                            ref.read(editIdProvider.notifier).state = true;
                            return notifier
                                .changeState(item.copyWith(title: value));
                          })),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
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
                              notifier.changeState(item.copyWith(date: date));
                            }
                          },
                          child: item.date == null
                              ? const Icon(Icons.calendar_month)
                              : Text(
                                  DateFormat('dd\nMMM\ny').format(item.date!),
                                  textAlign: TextAlign.center,
                                )),
                    ),
                    Flexible(
                      child: TextFieldWithConfirm(
                        key: Key(item.description),
                        text: item.description,
                        onConfirm: (value) {
                          notifier
                              .changeState(item.copyWith(description: value));
                        },
                        lable: 'Description',
                      ),
                    ),
                  ],
                ),
                PrioritySliderWidget(
                  initValue: item.priority,
                  setValue: (val) {
                    notifier.changeState(item.copyWith(priority: val.round()));
                  },
                ),
                TagsWidget(
                  key: Key(item.tags.hashCode.toString()),
                  tags: item.tags,
                  updateTags: (t) =>
                      notifier.changeState(item.copyWith(tags: t)),
                ),
                const AttachementsPreviewWidget(),
                UsedPartsWidget(
                  update: (usedParts) {
                    notifier.changeState(item.copyWith(usedParts: usedParts));
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
}
