import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:tagged_todos_organizer/notifications/domain/reminder.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tagged_todos_organizer/notifications/data/i_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

class LocalNotificationsService implements INotifications {
  final String channel = 'tagged_todos_organizer';
  int lastUsedId = 0;

  @override
  Future<void> init() async {
    _configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Tagged todos organizer',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );

    final winInitSettings = WindowsInitializationSettings(
      appName: 'tagged_todos_organizer',
      appUserModelId: 'Com.example.tagged_todos_organizer',
      guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
      windows: winInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotificationStream.add,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @override
  Future<void> scheduleNotification({
    required Reminder notification,
  }) async {
    NotificationDetails notificationDetails = NotificationDetails();
    if (Platform.isAndroid) {
      const int insistentFlag = 4;
      final androidNotificationDetails = AndroidNotificationDetails(
          channel, channel,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          additionalFlags: Int32List.fromList(<int>[insistentFlag]));
      notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
    } else {
      notificationDetails = NotificationDetails(
          linux: LinuxNotificationDetails(),
          windows: WindowsNotificationDetails());
    }

    final id = lastUsedId + 1;
    final payload = {
      "sourceTodoId": notification.sourceTodoId,
      "time": notification.time.millisecondsSinceEpoch.toString()
    };
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        notification.title,
        notification.message,
        _mapDateTime(notification.time),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: jsonEncode(payload));
    lastUsedId = id;
  }

  tz.TZDateTime _mapDateTime(DateTime date) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, date.year, date.month,
        date.day, date.hour, date.minute, date.second + 5);
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    if (Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    if (Platform.isWindows) {
      return;
    }
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  @override
  Stream<Reminder> getNotifications() async* {
    final notifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (final n in notifications) {
      try {
        final payload = jsonDecode(n.payload ?? '{}');
        final title = n.title;
        final message = n.body;
        final sourceTodoId = payload['sourceTodoId'];
        final millis = int.tryParse(payload['time']);

        if (title == null ||
            message == null ||
            sourceTodoId == null ||
            millis == null) {
          continue;
        }
        final time = DateTime.fromMillisecondsSinceEpoch(millis);
        yield Reminder(
            id: n.id,
            title: n.title ?? '',
            message: n.body ?? '',
            sourceTodoId: payload['sourceTodoId'],
            time: time);
      } catch (_) {
        continue;
      }
    }
  }

  @override
  Future<void> cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  void onReminderTap(Function(String) callback) {
    selectNotificationStream.stream
        .listen((NotificationResponse? response) async {
      if (response == null) return;
      final payload = jsonDecode(response.payload ?? '{}');
      final todoId = payload['sourceTodoId'];
      if (todoId == null) return;
      callback(todoId);
    });
  }

  void dispose() {
    selectNotificationStream.close();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}
