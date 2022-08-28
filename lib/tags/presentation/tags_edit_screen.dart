import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tag_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_edit_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/search_panel_widget.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class TagsEditScreen extends ConsumerWidget {
  const TagsEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(val.msg ?? '')));
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => ref.read(tagsProvider.notifier).addTag(),
              icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TagEditWidget(),
            TagSelectWidget(
              onPress: (e) => _setToEdit(ref, e),
              onDelete: (e) => ref.read(tagsProvider.notifier).deleteTag(e.id),
            ),
          ],
        ),
      ),
      floatingActionButton: SearchPanelWidget(
        onSearch: (String val) {
          ref.read(tagsFilter.notifier).update((state) => val);
        },
        tagsSort: true,
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
