import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';

class SearchPanelWidget extends ConsumerWidget {
  const SearchPanelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: TextField(
          onChanged: (String val) {
            ref.read(tagsFilter.notifier).update((state) => val);
          },
          decoration: const InputDecoration(
            labelText: 'Search',
            icon: Icon(Icons.filter_alt),
          )),
      trailing: DropdownButton<TagsSortOption>(
          value: ref.watch(tagsSortOrder),
          items: TagsSortOption.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(tagsSortOrder.notifier).update((state) => val);
            }
          }),
    );
  }
}
