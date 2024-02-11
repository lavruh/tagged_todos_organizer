import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

final filterByTagsProvider =
StateNotifierProvider<FilterByTagsNotifier, List<UniqueId>>(
        (ref) => FilterByTagsNotifier());

class FilterByTagsNotifier extends StateNotifier<List<UniqueId>> {
  FilterByTagsNotifier() : super([]);
  addFilter(UniqueId id) => state = [...state, id];
  removeFilter(UniqueId id) =>
      state = [...state.where((element) => element != id)];
  toggleFilter(UniqueId id) {
    if (state.contains(id)) {
      removeFilter(id);
    } else {
      addFilter(id);
    }
  }

  bool isSelected(UniqueId id) {
    return state.contains(id);
  }

  clearFilter() => state = [];
  List<UniqueId> getFilters() => state;
}
