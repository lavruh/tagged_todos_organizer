import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/selected_tags_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class TagsPreviewWidget extends ConsumerWidget {
  const TagsPreviewWidget({
    Key? key,
    required this.tags,
    this.onTap,
  }) : super(key: key);
  final List<UniqueId> tags;
  final Function? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTags = ref.watch(selectedTagsProvider([...tags]));
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width * 0.9,
        child: tags.isEmpty
            ? const Text('Tags:')
            : Wrap(
                children: selectedTags
                    .map((e) => Transform.scale(
                          scale: 0.8,
                          child: InputChip(
                            label: Text(e.name),
                            backgroundColor: Color(e.color),
                            onPressed: () {
                              if (onTap != null) onTap!();
                            },
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
