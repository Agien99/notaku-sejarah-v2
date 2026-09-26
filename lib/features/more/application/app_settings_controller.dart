import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTextSize {
  small(label: 'Kecil', scale: 0.9),
  standard(label: 'Standard', scale: 1.0),
  large(label: 'Besar', scale: 1.15);

  const AppTextSize({required this.label, required this.scale});

  final String label;
  final double scale;
}

class AppSettingsController extends ChangeNotifier {
  static const _textSizeKey = 'app_text_size';

  AppTextSize _textSize = AppTextSize.standard;
  bool _userChangedTextSize = false;

  AppTextSize get textSize => _textSize;

  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final storedValue = preferences.getString(_textSizeKey);

      if (_userChangedTextSize || storedValue == null) {
        return;
      }

      final loadedValue = AppTextSize.values.where(
        (value) => value.name == storedValue,
      );

      if (loadedValue.isEmpty) {
        return;
      }

      _textSize = loadedValue.first;
      notifyListeners();
    } catch (_) {
      // Keep the safe default when local preferences are unavailable.
    }
  }

  Future<void> setTextSize(AppTextSize value) async {
    if (_textSize == value) {
      return;
    }

    _userChangedTextSize = true;
    _textSize = value;
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_textSizeKey, value.name);
    } catch (_) {
      // The selected value still applies for the current app session.
    }
  }
}
