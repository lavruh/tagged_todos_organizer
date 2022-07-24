import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

void main() {
  test('Mapping simple todo', () {
    final item = ToDo.empty();
    final map = item.toMap();
    expect(map.keys, contains('id'));
    expect(map['id'], isNotEmpty);
    expect(map.keys, contains('title'));
    expect(map.keys, contains('description'));
    expect(map.keys, contains('tags'));
    expect(map['tags'], isEmpty);
  });

  test('Mapping todo with tags', () {
    final item = ToDo.empty();
    const tagName1 = 'newTag';
    item.tags.add(UniqueId(id: tagName1));
    final map = item.toMap();
    expect(map.keys, contains('id'));
    expect(map['id'], isNotEmpty);
    expect(map.keys, contains('title'));
    expect(map.keys, contains('description'));
    expect(map.keys, contains('tags'));
    expect(map['tags'], contains(tagName1));
    final todoFromDb = ToDo.fromMap(map);
    expect(todoFromDb.tags, item.tags);
  });
}
