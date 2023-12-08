import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/selected_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_widget.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagsPreviewWidget extends ConsumerWidget {
  const TagsPreviewWidget({
    super.key,
    required this.tags,
    this.onTap,
    this.onTapTag,
  });
  final List<UniqueId> tags;
  final Function? onTap;
  final Function(Tag)? onTapTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTags = ref.watch(selectedTagsProvider([...tags]));
    return tags.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
                child: Text(
                  'Tags:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  if (onTap != null) onTap!();
                }),
          )
        : GestureDetector(
            onTap: () {
              if (onTap != null) onTap!();
            },
            child: Wrap(
              children: selectedTags
                  .map((e) => TagWidget(
                        e: e,
                        onPress: onTapTag,
                      ))
                  .toList(),
            ),
          );
  }
}
