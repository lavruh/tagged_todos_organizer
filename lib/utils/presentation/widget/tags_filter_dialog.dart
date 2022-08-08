import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';

class TagsFilterDialog extends ConsumerWidget {
  const TagsFilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65),
        child: SingleChildScrollView(
          child: TagSelectWidget(
            selectedTags: ref.watch(todosFilterByTags),
            onPress: (tag) =>
                ref.read(todosFilterByTags.notifier).toggleFilter(tag.id),
          ),
        ),
      ),
    );
  }
}
