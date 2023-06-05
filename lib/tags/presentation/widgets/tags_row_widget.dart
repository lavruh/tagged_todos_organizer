import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_from_string_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';

class TagsRowWidget extends ConsumerWidget {
  const TagsRowWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagList = ref.watch(tagsFromStringProvider);
    final filter = ref.read(todosFilterByTags.notifier);

    return Wrap(
      children: tagList
          .map((e) => TagWidget(
                e: e,
                selected:
                    ref.watch(todosFilterByTags.notifier).isSelected(e.id),
                onPress: (tag) => filter.toggleFilter(tag.id),
              ))
          .toList(),
    );
  }
}
