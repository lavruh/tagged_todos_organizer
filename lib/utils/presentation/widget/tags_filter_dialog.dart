import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filters_by_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';

class TagsFilterDialog extends ConsumerWidget {
  const TagsFilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.read(filterByTagsProvider.notifier);
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
                selectedTags: ref.watch(filterByTagsProvider),
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
