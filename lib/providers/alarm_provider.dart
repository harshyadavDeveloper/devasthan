import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class AlarmProvider extends ChangeNotifier {
  static const _boxName = 'alarm_box';
  static const _keyHour = 'alarm_hour';
  static const _keyMinute = 'alarm_minute';
  static const _keyEnabled = 'alarm_enabled';
  static const _notifId = 1001;

  final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  late Box _box;
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 0);
  bool _enabled = false;

  TimeOfDay get time => _time;
  bool get enabled => _enabled;

  // How long until next alarm fires
  Duration get timeUntilAlarm {
    final now = DateTime.now();
    var target =
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    return target.difference(now);
  }

  String get timeLabel {
    final period = _time.hour < 12 ? 'AM' : 'PM';
    final hour12 = _time.hourOfPeriod == 0 ? 12 : _time.hourOfPeriod;
    final m = _time.minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$m $period';
  }

  // e.g. "in 3 hours 20 minutes" or "in 45 minutes"
  String get timeUntilLabel {
    final d = timeUntilAlarm;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0 && m > 0) return 'in $h hr ${m} min';
    if (h > 0) return 'in $h hour${h == 1 ? '' : 's'}';
    return 'in $m minute${m == 1 ? '' : 's'}';
  }

  Future<void> init() async {
    tz_data.initializeTimeZones();

    _box = await Hive.openBox(_boxName);
    _time = TimeOfDay(
      hour: _box.get(_keyHour, defaultValue: 6),
      minute: _box.get(_keyMinute, defaultValue: 0),
    );
    _enabled = _box.get(_keyEnabled, defaultValue: false);

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notif.initialize(settings);

    // Request permissions
    await _notif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    if (_enabled) await _schedule();
  }

  Future<void> setTime(TimeOfDay time) async {
    _time = time;
    await _box.put(_keyHour, time.hour);
    await _box.put(_keyMinute, time.minute);
    if (_enabled) await _schedule();
    notifyListeners();
  }

  Future<void> toggleAlarm(bool val) async {
    _enabled = val;
    await _box.put(_keyEnabled, val);
    if (val) {
      await _schedule();
    } else {
      await _notif.cancel(_notifId);
    }
    notifyListeners();
  }

  Future<void> _schedule() async {
    await _notif.cancel(_notifId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _time.hour,
      _time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final androidDetails = AndroidNotificationDetails(
      'devasthan_aarti_channel',
      'Daily Aarti Alarm',
      channelDescription: 'Daily aarti reminder from Devasthan',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    await _notif.zonedSchedule(
      _notifId,
      '🙏 Time for Aarti',
      'Your daily devotion awaits. Jai Shri Ram! 🪔',
      scheduled,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
