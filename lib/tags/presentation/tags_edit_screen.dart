import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_edit_widget.dart';

class TagsEditScreen extends ConsumerWidget {
  const TagsEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredTagsProvider);
    final tagToEdit = ref.watch(tagEditorProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<TagsSortOption>(
              value: ref.watch(tagsSortOrder),
              items: TagsSortOption.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  ref.read(tagsSortOrder.notifier).update((state) => val);
                }
              }),
          IconButton(
            onPressed: () => ref.read(tagsProvider.notifier).addTag(),
            icon: const Icon(Icons.add),
          ),
        ],
        title: TextField(
          onChanged: (String val) {
            ref.read(tagsFilter.notifier).update((state) => val);
          },
          decoration: const InputDecoration(
              labelText: 'Search', icon: Icon(Icons.filter_alt)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AnimatedCrossFade(
                firstChild: Container(),
                secondChild: tagToEdit != null
                    ? TagEditWidget(editor: tagToEdit)
                    : Container(),
                crossFadeState: tagToEdit != null
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250)),
            SingleChildScrollView(
              child: Wrap(
                spacing: 5,
                children: items.map((e) {
                  return InputChip(
                    label: Text(e.name),
                    backgroundColor: Color(e.color),
                    onPressed: () {
                      ref.read(tagEditorProvider.notifier).update(
                          (state) => TagEditor(item: e, isChanged: false));
                    },
                    onDeleted: () {
                      ref.read(tagsProvider.notifier).deleteTag(e.id);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
