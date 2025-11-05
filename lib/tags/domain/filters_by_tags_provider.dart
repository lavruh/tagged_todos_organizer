import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final filterByTagsProvider =
    NotifierProvider<FilterByTagsNotifier, List<UniqueId>>(
        () => FilterByTagsNotifier());

class FilterByTagsNotifier extends Notifier<List<UniqueId>> {
  @override
  List<UniqueId> build() => [];

  void addFilter(UniqueId id) => state = [...state, id];
  void removeFilter(UniqueId id) =>
      state = [...state.where((element) => element != id)];
  void toggleFilter(UniqueId id) {
    if (state.contains(id)) {
      removeFilter(id);
    } else {
      addFilter(id);
    }
  }

  bool isSelected(UniqueId id) {
    return state.contains(id);
  }

  void clearFilter() => state = [];
  List<UniqueId> getFilters() => state;
}
