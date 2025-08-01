import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagged_todos_organizer/app.dart';
import 'package:tagged_todos_organizer/notifications/data/i_notifications.dart';
import 'package:tagged_todos_organizer/notifications/data/local_notifications_service.dart';
import 'package:tagged_todos_organizer/todos/domain/todo.dart';
import 'package:tagged_todos_organizer/todos/domain/todo_editor_provider.dart';
import 'package:tagged_todos_organizer/todos/domain/todos_provider.dart';
import 'package:tagged_todos_organizer/utils/unique_id.dart';

import 'reminder.dart';

final notificationsServiceProvider = StateProvider<INotifications>((ref) {
  final service = LocalNotificationsService();
  service.init();
  return service;
});

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<Reminder>>((ref) {
  final service = ref.watch(notificationsServiceProvider);

  service.onReminderTap((todoId) async {
    final id = UniqueId(id: todoId);
    final t =
    ref.watch(todosProvider).firstWhere((element) => element.id == id);
    await ref.read(todoEditorProvider.notifier).setTodo(t);
    ref.read(routerProvider).go('/TodoEditorScreen');
  });

  return NotificationsNotifier(service);
});

class NotificationsNotifier extends StateNotifier<List<Reminder>> {
  final INotifications service;
  NotificationsNotifier(this.service) : super([]);

  void getNotifications() async {
    final stream = service.getNotifications();
    state = [];
    await for (final notification in stream) {
      state = [...state, notification];
    }
  }

  Future<void> schedule({
    required ToDo todo,
    String? message,
    required DateTime time,
  }) async {
    service.scheduleNotification(
        notification: Reminder.fromToDo(todo, time: time, message: message));
  }

  void cancel(int reminderId) async {
    await service.cancelNotification(id: reminderId);
    getNotifications();
  }
}
