import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ── Models ─────────────────────────────────────────────────────

class DeityModel {
  final String id;
  final String name;
  final String emoji;
  final String tradition;

  const DeityModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.tradition,
  });
}

class PlacedItem {
  final String uid;
  final String emoji;
  final String label;
  Offset position;

  PlacedItem({
    required this.uid,
    required this.emoji,
    required this.label,
    required this.position,
  });

  // ── Hive serialization ─────────────────────────────────────
  Map<String, dynamic> toMap() => {
    'uid':   uid,
    'emoji': emoji,
    'label': label,
    'dx':    position.dx,
    'dy':    position.dy,
  };

  factory PlacedItem.fromMap(Map map) => PlacedItem(
    uid:      map['uid']   as String,
    emoji:    map['emoji'] as String,
    label:    map['label'] as String,
    position: Offset(
      (map['dx'] as num).toDouble(),
      (map['dy'] as num).toDouble(),
    ),
  );
}

// ── Provider ───────────────────────────────────────────────────

class MandirProvider extends ChangeNotifier {
  static const _boxName      = 'mandir_box';
  static const _keyItems     = 'items';
  static const _keyName      = 'mandir_name';

  late Box _box;
  String _mandirName = 'My Mandir';
  final List<PlacedItem> _items = [];

  String           get mandirName => _mandirName;
  List<PlacedItem> get items      => List.unmodifiable(_items);
  bool             get isEmpty    => _items.isEmpty;

  // ── Init ───────────────────────────────────────────────────
  Future<void> init() async {
    _box        = await Hive.openBox(_boxName);
    _mandirName = _box.get(_keyName, defaultValue: 'My Mandir');

    final saved = _box.get(_keyItems, defaultValue: []);
    _items.clear();
    for (final raw in saved) {
      try {
        _items.add(PlacedItem.fromMap(Map.from(raw)));
      } catch (_) {}
    }
    notifyListeners();
  }

  // ── Save to Hive ───────────────────────────────────────────
  Future<void> _persist() async {
    await _box.put(_keyItems, _items.map((i) => i.toMap()).toList());
  }

  // ── Deity Catalog ──────────────────────────────────────────
  static const List<DeityModel> deities = [
    DeityModel(id: 'ganesha',    name: 'Ganesha',   emoji: '🐘', tradition: 'All'),
    DeityModel(id: 'shiva',      name: 'Shiva',     emoji: '🔱', tradition: 'Shaivite'),
    DeityModel(id: 'vishnu',     name: 'Vishnu',    emoji: '🪷', tradition: 'Vaishnavite'),
    DeityModel(id: 'lakshmi',    name: 'Lakshmi',   emoji: '🌸', tradition: 'Vaishnavite'),
    DeityModel(id: 'durga',      name: 'Durga',     emoji: '⚔️', tradition: 'Shakta'),
    DeityModel(id: 'krishna',    name: 'Krishna',   emoji: '🦚', tradition: 'Vaishnavite'),
    DeityModel(id: 'rama',       name: 'Rama',      emoji: '🏹', tradition: 'Vaishnavite'),
    DeityModel(id: 'saraswati',  name: 'Saraswati', emoji: '🎵', tradition: 'Shakta'),
    DeityModel(id: 'hanuman',    name: 'Hanuman',   emoji: '🙏', tradition: 'All'),
  ];

  // ── Decor Catalog ──────────────────────────────────────────
  static const List<DeityModel> decor = [
    DeityModel(id: 'diya',    name: 'Diya',    emoji: '🪔', tradition: ''),
    DeityModel(id: 'flower',  name: 'Flower',  emoji: '🌺', tradition: ''),
    DeityModel(id: 'bell',    name: 'Bell',    emoji: '🔔', tradition: ''),
    DeityModel(id: 'incense', name: 'Incense', emoji: '🧨', tradition: ''),
    DeityModel(id: 'lotus',   name: 'Lotus',   emoji: '🪷', tradition: ''),
    DeityModel(id: 'coconut', name: 'Coconut', emoji: '🥥', tradition: ''),
    DeityModel(id: 'candle',  name: 'Candle',  emoji: '🕯️', tradition: ''),
    DeityModel(id: 'star',    name: 'Star',    emoji: '⭐', tradition: ''),
  ];

  // ── Actions ────────────────────────────────────────────────
  void addItem(String emoji, String label) {
    if (_items.length >= 20) return;
    _items.add(PlacedItem(
      uid:      '${label}_${DateTime.now().millisecondsSinceEpoch}',
      emoji:    emoji,
      label:    label,
      position: const Offset(0.4, 0.4),
    ));
    _persist();
    notifyListeners();
  }

  void moveItem(String uid, Offset newPosition) {
    final idx = _items.indexWhere((i) => i.uid == uid);
    if (idx != -1) {
      _items[idx].position = Offset(
        newPosition.dx.clamp(0.0, 1.0),
        newPosition.dy.clamp(0.0, 1.0),
      );
      _persist();
      notifyListeners();
    }
  }

  void removeItem(String uid) {
    _items.removeWhere((i) => i.uid == uid);
    _persist();
    notifyListeners();
  }

  void setMandirName(String name) {
    _mandirName = name.trim().isEmpty ? 'My Mandir' : name.trim();
    _box.put(_keyName, _mandirName);
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _persist();
    notifyListeners();
  }
}