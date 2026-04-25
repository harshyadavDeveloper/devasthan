import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StreakProvider extends ChangeNotifier {
  static const _boxName = 'streak_box';
  static const _keyStreak = 'streak';
  static const _keyLast = 'last_open';

  late Box _box;
  int _streak = 0;

  int get streak => _streak;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _streak = _box.get(_keyStreak, defaultValue: 0);
    _checkStreak();
  }

  void _checkStreak() {
    final lastStr = _box.get(_keyLast, defaultValue: '');
    final today = _todayStr();

    if (lastStr == today) {
      // already opened today, nothing to do
      return;
    }

    final yesterday =
        _dateStr(DateTime.now().subtract(const Duration(days: 1)));

    if (lastStr == yesterday) {
      // opened yesterday → increment streak
      _streak++;
    } else if (lastStr.isEmpty) {
      // first ever open
      _streak = 1;
    } else {
      // missed a day → reset
      _streak = 1;
    }

    _box.put(_keyStreak, _streak);
    _box.put(_keyLast, today);
    notifyListeners();
  }

  void reset() {
    _streak = 0;
    _box.put(_keyStreak, 0);
    notifyListeners();
  }

  String _todayStr() => _dateStr(DateTime.now());
  String _dateStr(DateTime d) => '${d.year}-${d.month}-${d.day}';
}
