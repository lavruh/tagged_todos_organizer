import 'package:flutter/material.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_alias.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_preview_widget.dart';

class TagsAliasWidget extends StatelessWidget {
  const TagsAliasWidget(
      {super.key,
      required this.alias,
      required this.onEdit,
      required this.onDelete});
  final TagsAlias alias;
  final Function(TagsAlias) onEdit;
  final Function(TagsAlias) onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: TextButton(
                onPressed: () => onEdit(alias), child: Text(alias.title))),
        Flexible(child: TagsPreviewWidget(tags: alias.tags)),
        IconButton(
            onPressed: () => onDelete(alias), icon: const Icon(Icons.delete)),
      ],
    );
  }
}
