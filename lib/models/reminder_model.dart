import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String userId;
  final bool isEnabled;
  final TimeOfDay time;
  final List<int> days;

  Reminder({
    required this.id,
    required this.userId,
    required this.isEnabled,
    required this.time,
    required this.days,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'isEnabled': isEnabled,
      'hour': time.hour,
      'minute': time.minute,
      'days': days,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      userId: map['userId'],
      isEnabled: map['isEnabled'],
      time: TimeOfDay(hour: map['hour'], minute: map['minute']),
      days: List<int>.from(map['days']),
    );
  }
}