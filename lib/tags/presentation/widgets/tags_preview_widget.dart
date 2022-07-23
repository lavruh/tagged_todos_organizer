import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
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
    final availableTags = ref.watch(tagsProvider);
    return ListTile(
      title: tags.isEmpty
          ? const Text('Tags:')
          : Wrap(
              children: availableTags
                  .where((element) => tags.contains(element.id))
                  .map((e) => InputChip(
                        label: Text(e.name),
                        backgroundColor: Color(e.color),
                        onPressed: () {},
                      ))
                  .toList(),
            ),
      onTap: () {
        if (onTap != null) onTap!();
      },
    );
  }
}
