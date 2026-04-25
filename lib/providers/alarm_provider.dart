import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  String get timeLabel {
    final h = _time.hour.toString().padLeft(2, '0');
    final m = _time.minute.toString().padLeft(2, '0');
    final period = _time.hour < 12 ? 'AM' : 'PM';
    final hour12 = _time.hourOfPeriod == 0 ? 12 : _time.hourOfPeriod;
    return '${hour12.toString().padLeft(2, '0')}:$m $period';
  }

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _time = TimeOfDay(
      hour: _box.get(_keyHour, defaultValue: 6),
      minute: _box.get(_keyMinute, defaultValue: 0),
    );
    _enabled = _box.get(_keyEnabled, defaultValue: false);

    // Init notifications
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notif.initialize(settings);
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
    // Daily repeating notification at chosen time
    const androidDetails = AndroidNotificationDetails(
      'devasthan_aarti',
      'Daily Aarti',
      channelDescription: 'Your daily morning aarti reminder',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails();
    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Schedule daily at chosen time
    // Using periodically for simplicity — upgrade to zonedSchedule for exact time in v2
    await _notif.periodicallyShow(
      _notifId,
      '🙏 Time for Aarti',
      'Your daily devotion awaits. Jai Shri Ram!',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
