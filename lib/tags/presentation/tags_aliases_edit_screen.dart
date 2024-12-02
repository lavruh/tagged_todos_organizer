import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_editor_provider.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_aliases_provider.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_alias_widget.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tags_alias_editor_widget.dart';

class TagsAliasesEditScreen extends ConsumerWidget {
  const TagsAliasesEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(tagsAliasesProvider).values;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        ...data.map((e) => TagsAliasWidget(
            alias: e,
            onDelete: (alias) => ref
                .read(tagsAliasesProvider.notifier)
                .deleteAlias(alias: alias),
            onEdit: (alias) => ref
                .read(tagsAliasesEditorProvider.notifier)
                .updateAlias(alias: alias))),
        const TagsAliasEditorWidget(),
      ]),
    );
  }
}
