import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ValueNotifier<Locale?> {
  static const _key = 'selected_locale';

  LocaleController() : super(null);

  /// Reads the persisted locale from SharedPreferences.
  /// Call once before runApp. If nothing is saved, value stays null and
  /// MaterialApp falls back to the system/browser language.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      super.value = Locale(code);
    }
  }

  /// Persists on every change; null removes the saved preference so the
  /// system locale is used again.
  @override
  set value(Locale? newValue) {
    super.value = newValue;
    SharedPreferences.getInstance().then((prefs) {
      if (newValue != null) {
        prefs.setString(_key, newValue.languageCode);
      } else {
        prefs.remove(_key);
      }
    });
  }
}

final localeController = LocaleController();
