import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/audio/app_audio.dart';

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
  static const _soundEnabledKey = 'app_sound_enabled';

  AppTextSize _textSize = AppTextSize.standard;
  bool _soundEnabled = true;
  bool _userChangedTextSize = false;
  bool _userChangedSound = false;

  AppTextSize get textSize => _textSize;
  bool get soundEnabled => _soundEnabled;

  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      var changed = false;

      if (!_userChangedTextSize) {
        final storedValue = preferences.getString(_textSizeKey);
        if (storedValue != null) {
          final loadedValue = AppTextSize.values.where(
            (value) => value.name == storedValue,
          );
          if (loadedValue.isNotEmpty && _textSize != loadedValue.first) {
            _textSize = loadedValue.first;
            changed = true;
          }
        }
      }

      if (!_userChangedSound) {
        final storedSound = preferences.getBool(_soundEnabledKey);
        if (storedSound != null && _soundEnabled != storedSound) {
          _soundEnabled = storedSound;
          changed = true;
        }
      }

      AppAudio.instance.enabled = _soundEnabled;

      if (changed) {
        notifyListeners();
      }
    } catch (_) {
      // Keep safe defaults when local preferences are unavailable.
      AppAudio.instance.enabled = _soundEnabled;
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

  Future<void> setSoundEnabled(bool value) async {
    if (_soundEnabled == value) {
      return;
    }

    _userChangedSound = true;
    _soundEnabled = value;
    AppAudio.instance.enabled = value;
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_soundEnabledKey, value);
    } catch (_) {
      // The selected value still applies for the current app session.
    }
  }
}
