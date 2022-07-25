import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/domain/filtered_tags_provider.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/tags_filter_dialog.dart';
import 'package:tagged_todos_organizer/utils/presentation/widget/text_field_with_clear_button.dart';

class SearchPanelWidget extends ConsumerWidget {
  const SearchPanelWidget({
    Key? key,
    required this.onSearch,
    this.tagsSort = false,
    this.tagsFilter = false,
  }) : super(key: key);
  final Function(String) onSearch;
  final bool tagsSort;
  final bool tagsFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          title: TextFieldWithClearButton(onChanged: onSearch),
          trailing: Wrap(
            children: [
              if (tagsSort)
                DropdownButton<TagsSortOption>(
                    value: ref.watch(tagsSortOrder),
                    items: TagsSortOption.values.map((e) {
                      final str = e.toString();
                      final lable = str.substring(str.lastIndexOf('.') + 1);
                      return DropdownMenuItem(value: e, child: Text(lable));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(tagsSortOrder.notifier).update((state) => val);
                      }
                    }),
              if (tagsFilter)
                IconButton(
                    onPressed: () => _showTagsFilter(context, ref),
                    icon: const Icon(Icons.label))
            ],
          ),
        ),
      ),
    );
  }

  void _showTagsFilter(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context, builder: (context) => const TagsFilterDialog());
  }
}
