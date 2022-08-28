import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';

class TagsFilterDialog extends ConsumerWidget {
  const TagsFilterDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.read(todosFilterByTags.notifier);
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () => filter.clearFilter(),
                child: const Text('Clear')),
            SingleChildScrollView(
              child: TagSelectWidget(
                selectedTags: ref.watch(todosFilterByTags),
                height: 0.3,
                onPress: (tag) => filter.toggleFilter(tag.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
