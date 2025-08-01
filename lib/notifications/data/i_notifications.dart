import 'package:tagged_todos_organizer/notifications/domain/reminder.dart';

abstract class INotifications {
  Future<void> scheduleNotification({required Reminder notification});

  Future<void> cancelNotification({required int id});

  Stream<Reminder> getNotifications();

  Future<void> init();

  void onReminderTap(Function(String) callback);
}
