import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tagged_todos_organizer/log/domain/log_entry.dart';
import 'package:tagged_todos_organizer/log/domain/log_provider.dart';
import 'package:tagged_todos_organizer/log/domain/loggable_action.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

import 'log_provider_test.mocks.dart';

class Listener extends Mock {
  void call(List<LogEntry>? previous, List<LogEntry> value);
}

@GenerateMocks([IDbService])
void main() {
  MockIDbService db = MockIDbService();
  ProviderContainer ref = ProviderContainer();

  setUp(() async {
    db = MockIDbService();
    ref = ProviderContainer();
    ref.listen<List<LogEntry>>(logProvider, Listener(), fireImmediately: true);
    await ref.read(logProvider.notifier).setDb(db);
  });

  tearDown(() => addTearDown(ref.dispose));

  test('add log entry from todo', () async {
    const action = LoggableAction.created;
    final todo = ToDo.empty().copyWith(title: 'test');
    final todoWithTags = ToDo.empty().copyWith(tags: [UniqueId()]);

    await ref
        .read(logProvider.notifier)
        .logActionWithTodo(action: action, todo: todo);
    await ref
        .read(logProvider.notifier)
        .logActionWithTodo(action: action, todo: todoWithTags);

    expect(ref.read(logProvider).length, 2);
    expect(ref.read(logProvider).first.title, todo.title);
    expect(ref.read(logProvider).first.date.day, DateTime.now().day);
    expect(ref.read(logProvider).last.tags, todoWithTags.tags);
    expect(ref.read(logProvider).last.action, action);
    verify(db.update(
            id: anyNamed('id'),
            item: anyNamed('item'),
            table: anyNamed('table')))
        .called(2);
  });

  test('get all entries from db', () async {
    final entries = List.generate(
        3,
        (index) => LogEntry.empty()
            .copyWith(id: UniqueId(id: '$index'), title: '$index'));
    when(db.getAll(table: 'log'))
        .thenAnswer((_) => Stream.fromIterable(entries.map((e) => e.toMap())));
    await ref.read(logProvider.notifier).getAllEntries();
    expect(ref.read(logProvider).length, 3);
  });
}
