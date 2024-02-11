import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filters_by_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_from_string_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';

class TagsRowWidget extends ConsumerWidget {
  const TagsRowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagList = ref.watch(tagsFromStringProvider);
    final filter = ref.read(filterByTagsProvider.notifier);

    return Wrap(
      children: tagList
          .map((e) => TagWidget(
                e: e,
                selected:
                    ref.watch(filterByTagsProvider.notifier).isSelected(e.id),
                onPress: (tag) => filter.toggleFilter(tag.id),
              ))
          .toList(),
    );
  }
}
