import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todolist/models/todotask.dart';
import 'package:timezone/timezone.dart' as tz;

class TodoNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TodoNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(TodotaskModel task) async {
    if(task.reminderDate == null) return;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Todolist',
      'Todolist',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    int id = task.createdDate.hashCode;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // Unique ID for each notification
      task.title, // Notification title
      'Don\'t forget to complete your task!', // Notification body
      tz.TZDateTime.from(task.reminderDate!, tz.local), // Reminder time
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time, // Ensure the notification triggers at the correct time
      androidScheduleMode: AndroidScheduleMode.exact, // Add the required androidScheduleMode parameter
    );
  }

  Future<void> cancelNotification(TodotaskModel task) async {
    int id = task.createdDate.hashCode;
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
