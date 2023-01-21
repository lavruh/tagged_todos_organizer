import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/tags/presentation/widgets/tag_select_widget.dart';
import 'package:tagged_todos_organizer/todos/domain/filtered_todos_provider.dart';

class FilterMenuWidget extends ConsumerWidget {
  const FilterMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.read(todosFilterByTags.notifier);

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Show future todos'),
            leading: ref.watch(todosFilterShowFutureDates)
                ? const Icon(Icons.data_exploration)
                : const Icon(Icons.data_exploration_outlined),
            onTap: () {
              final flag = ref.read(todosFilterShowFutureDates);
              ref
                  .read(todosFilterShowFutureDates.notifier)
                  .update((state) => !flag);
            },
          ),
          ListTile(
              title: const Text('Show done todos'),
              leading: ref.watch(todosFilterShowUnDone)
                  ? const Icon(Icons.check_box_outline_blank)
                  : const Icon(Icons.check_box),
              onTap: () {
                final flag = ref.read(todosFilterShowUnDone);
                ref
                    .read(todosFilterShowUnDone.notifier)
                    .update((state) => !flag);
              }),
          ListTile(
            title: const Text('Show subtodos'),
            leading: ref.watch(todosFilterShowAll)
                ? const Icon(Icons.account_tree)
                : const Icon(Icons.account_tree_outlined),
            onTap: () {
              final flag = ref.read(todosFilterShowAll);
              ref.read(todosFilterShowAll.notifier).update((state) => !flag);
            },
          ),
          ListTile(
            title: const Text('Filter by date'),
            leading: ref.watch(todosFilterByDate) == null
                ? const Icon(Icons.calendar_month_outlined)
                : const Icon(Icons.calendar_month),
            onTap: () async {
              final range = await showDateRangePicker(
                  context: context,
                  initialDateRange: ref.watch(todosFilterByDate),
                  firstDate: DateTime(DateTime.now().year - 3),
                  lastDate: DateTime(DateTime.now().year + 3));
              ref.read(todosFilterByDate.notifier).update((state) => range);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => filter.clearFilter(),
                  child: const Text('Clear')),
              SingleChildScrollView(
                child: TagSelectWidget(
                  selectedTags: ref.watch(todosFilterByTags),
                  height: 0.5,
                  onPress: (tag) => filter.toggleFilter(tag.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
