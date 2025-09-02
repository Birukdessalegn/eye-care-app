import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../constants/app_constants.dart';

class ReminderService with ChangeNotifier {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isEnabled = false;
  TimeOfDay? _reminderTime;
  bool _isLoading = false;

  bool get isEnabled => _isEnabled;
  TimeOfDay? get reminderTime => _reminderTime;
  bool get isLoading => _isLoading;

  ReminderService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(AppConstants.reminderEnabledKey) ?? false;

    final hour = prefs.getInt(AppConstants.reminderHourKey);
    final minute = prefs.getInt(AppConstants.reminderMinuteKey);

    if (hour != null && minute != null) {
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    }

    notifyListeners();
  }

  Future<void> _saveReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.reminderEnabledKey, _isEnabled);

    if (_reminderTime != null) {
      await prefs.setInt(AppConstants.reminderHourKey, _reminderTime!.hour);
      await prefs.setInt(AppConstants.reminderMinuteKey, _reminderTime!.minute);
    }
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    setState(() {
      _isLoading = true;
    });

    _isEnabled = true;
    _reminderTime = time;

    await _saveReminderSettings();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'eye_care_reminder',
          'Eye Care Reminder',
          channelDescription: 'Reminders for eye exercises and breaks',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the scheduled time is in the past, schedule for tomorrow
    final scheduledDate = scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;

    await notificationsPlugin.zonedSchedule(
      0,
      'Time for Eye Care!',
      'Take a break and do some eye exercises to reduce strain.',
      scheduledDate,
      platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    setState(() {
      _isLoading = false;
    });
    notifyListeners();
  }

  Future<void> cancelReminder() async {
    setState(() {
      _isLoading = true;
    });

    _isEnabled = false;
    await _saveReminderSettings();
    await notificationsPlugin.cancel(0);

    setState(() {
      _isLoading = false;
    });
    notifyListeners();
  }

  void setState(void Function() callback) {
    callback();
    notifyListeners();
  }
}
