import 'package:hive_flutter/hive_flutter.dart';

class Cache {
  factory Cache() => _instance;

  Cache._();

  static final Cache _instance = Cache._();

  String get box => 'cache';

  Future<void> init() async {
    await Hive.initFlutter();
    // Initialize box if not already open
    if (!Hive.isBoxOpen(box)) {
      await Hive.openBox(box);
    }
  }

  Iterable getAllKeys() {
    final hiveBox = Hive.box(box);
    return hiveBox.keys;
  }

  dynamic get(String key) {
    final hiveBox = Hive.box(box);
    return hiveBox.get(key);
  }

  Future<void> put(String key, dynamic value) async {
    final hiveBox = Hive.box(box);
    await hiveBox.put(key, value);
  }

  Future<void> delete(String key) async {
    final hiveBox = Hive.box(box);
    await hiveBox.delete(key);
  }

  Future<void> clear() async {
    // Clear each open box
    if (Hive.isBoxOpen(box)) {
      final hiveBox = Hive.box(box);
      await hiveBox.clear();
    }
  }
}
