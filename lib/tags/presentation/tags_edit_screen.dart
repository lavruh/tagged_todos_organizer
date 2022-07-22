import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/search_panel_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_edit_widget.dart';

class TagsEditScreen extends ConsumerWidget {
  const TagsEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredTagsProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => ref.read(tagsProvider.notifier).addTag(),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const TagEditWidget(),
                SingleChildScrollView(
                  child: Wrap(
                    spacing: 3,
                    children: items.map((e) {
                      return InputChip(
                        label: Text(e.name),
                        backgroundColor: Color(e.color),
                        onPressed: () => _setToEdit(ref, e),
                        onDeleted: () =>
                            ref.read(tagsProvider.notifier).deleteTag(e.id),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SearchPanelWidget(),
        ],
      ),
    );
  }

  _setToEdit(WidgetRef ref, Tag e) {
    {
      ref
          .read(tagEditorProvider.notifier)
          .update((state) => TagEditor(item: e, isChanged: false));
    }
  }
}
