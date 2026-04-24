import 'package:flutter/material.dart';

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
  Offset position; // normalized 0.0 to 1.0

  PlacedItem({
    required this.uid,
    required this.emoji,
    required this.label,
    required this.position,
  });
}

// ── Provider ───────────────────────────────────────────────────

class MandirProvider extends ChangeNotifier {
  String _mandirName = 'My Mandir';
  final List<PlacedItem> _items = [];

  String get mandirName => _mandirName;
  List<PlacedItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  // ── Deity Catalog ──────────────────────────────────────────
  static const List<DeityModel> deities = [
    DeityModel(id: 'ganesha', name: 'Ganesha', emoji: '🐘', tradition: 'All'),
    DeityModel(id: 'shiva', name: 'Shiva', emoji: '🔱', tradition: 'Shaivite'),
    DeityModel(
        id: 'vishnu', name: 'Vishnu', emoji: '🪷', tradition: 'Vaishnavite'),
    DeityModel(
        id: 'lakshmi', name: 'Lakshmi', emoji: '🌸', tradition: 'Vaishnavite'),
    DeityModel(id: 'durga', name: 'Durga', emoji: '⚔️', tradition: 'Shakta'),
    DeityModel(
        id: 'krishna', name: 'Krishna', emoji: '🦚', tradition: 'Vaishnavite'),
    DeityModel(id: 'rama', name: 'Rama', emoji: '🏹', tradition: 'Vaishnavite'),
    DeityModel(
        id: 'saraswati', name: 'Saraswati', emoji: '🎵', tradition: 'Shakta'),
    DeityModel(id: 'hanuman', name: 'Hanuman', emoji: '🙏', tradition: 'All'),
  ];

  // ── Decor Catalog ──────────────────────────────────────────
  static const List<DeityModel> decor = [
    DeityModel(id: 'diya', name: 'Diya', emoji: '🪔', tradition: ''),
    DeityModel(id: 'flower', name: 'Flower', emoji: '🌺', tradition: ''),
    DeityModel(id: 'bell', name: 'Bell', emoji: '🔔', tradition: ''),
    DeityModel(id: 'incense', name: 'Incense', emoji: '🧨', tradition: ''),
    DeityModel(id: 'lotus', name: 'Lotus', emoji: '🪷', tradition: ''),
    DeityModel(id: 'coconut', name: 'Coconut', emoji: '🥥', tradition: ''),
    DeityModel(id: 'candle', name: 'Candle', emoji: '🕯️', tradition: ''),
    DeityModel(id: 'star', name: 'Star', emoji: '⭐', tradition: ''),
  ];

  // ── Actions ────────────────────────────────────────────────

  void addItem(String emoji, String label) {
    if (_items.length >= 20) return;
    _items.add(PlacedItem(
      uid: '${label}_${DateTime.now().millisecondsSinceEpoch}',
      emoji: emoji,
      label: label,
      position: const Offset(0.4, 0.4),
    ));
    notifyListeners();
  }

  void moveItem(String uid, Offset newPosition) {
    final idx = _items.indexWhere((i) => i.uid == uid);
    if (idx != -1) {
      _items[idx].position = Offset(
        newPosition.dx.clamp(0.0, 1.0),
        newPosition.dy.clamp(0.0, 1.0),
      );
      notifyListeners();
    }
  }

  void removeItem(String uid) {
    _items.removeWhere((i) => i.uid == uid);
    notifyListeners();
  }

  void setMandirName(String name) {
    _mandirName = name.trim().isEmpty ? 'My Mandir' : name.trim();
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }

  // TODO Phase 3 persistence: save/load with Hive
}
