import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/settings/domain/tag_height_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';

class TagWidget extends ConsumerWidget {
  const TagWidget({
    super.key,
    required this.e,
    this.selected = false,
    this.onPress,
    this.onDelete,
  });
  final Tag e;
  final bool selected;
  final Function(Tag)? onPress;
  final Function(Tag)? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 25 * ref.watch(tagHeightProvider),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: InputChip(
            label: Text(e.name),
            selected: selected,
            backgroundColor: Color(e.color),
            selectedColor: Color(e.color),
            onPressed: () {
              if (onPress != null) onPress!(e);
            },
          ),
        ),
      ),
    );
  }
}
