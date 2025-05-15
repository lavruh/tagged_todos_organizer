import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/tags/domain/tag.dart';
import 'package:tagged_todos_organizer/tags/domain/tags_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

class Listener extends Mock {
  void call(List<Tag>? previous, List<Tag> value);
}

void main() {
  test('check if tag with id exists', () {
    final tag = Tag.empty();
    final tag2 = Tag(id: UniqueId(id: 'n'), name: 'n', color: 0, group: '');
    final ref = ProviderContainer();
    addTearDown(ref.dispose);
    final listener = Listener();
    ref.listen<List<Tag>>(tagsProvider, listener.call, fireImmediately: true);

    ref.read(tagsProvider.notifier).updateTag(tag);
    ref.read(tagsProvider.notifier).updateTag(tag2);

    expect(tag != tag2, true);
    expect(ref.read(tagsProvider).length, 2);
    expect(ref.read(tagsProvider), contains(tag));
    expect(ref.read(tagsProvider.notifier).isTagIdExists(tag.id), true);
  });
}
