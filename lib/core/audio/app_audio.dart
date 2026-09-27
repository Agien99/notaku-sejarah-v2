import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum AppSoundEffect { answerSelected, quizComplete, quizHighScore }

class AppAudio {
  AppAudio._();

  static final AppAudio instance = AppAudio._();

  AudioPlayer? _player;
  final Map<AppSoundEffect, Uint8List> _cache = {};
  bool _suppressPlaybackForTests = false;

  bool enabled = true;

  @visibleForTesting
  void setPlaybackSuppressedForTests(bool value) {
    _suppressPlaybackForTests = value;
  }

  Future<void> play(AppSoundEffect effect) async {
    if (!enabled || _suppressPlaybackForTests) {
      return;
    }

    try {
      final bytes = _cache.putIfAbsent(effect, () => _buildEffect(effect));
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(
        BytesSource(bytes, mimeType: 'audio/wav'),
        volume: effect == AppSoundEffect.answerSelected ? 0.48 : 0.62,
      );
    } catch (_) {
      // Sound is optional. Never block learning if a platform cannot play it.
    }
  }

  Uint8List _buildEffect(AppSoundEffect effect) {
    return switch (effect) {
      AppSoundEffect.answerSelected => _buildWav([const _Tone(740, 0.055)]),
      AppSoundEffect.quizComplete => _buildWav([
        const _Tone(523.25, 0.10, gapSeconds: 0.018),
        const _Tone(659.25, 0.10, gapSeconds: 0.018),
        const _Tone(783.99, 0.18),
      ]),
      AppSoundEffect.quizHighScore => _buildWav([
        const _Tone(523.25, 0.08, gapSeconds: 0.015),
        const _Tone(659.25, 0.08, gapSeconds: 0.015),
        const _Tone(783.99, 0.08, gapSeconds: 0.015),
        const _Tone(1046.50, 0.20),
      ]),
    };
  }

  Uint8List _buildWav(List<_Tone> tones) {
    const sampleRate = 16000;
    const bytesPerSample = 2;
    final samples = <int>[];

    for (final tone in tones) {
      final sampleCount = (sampleRate * tone.durationSeconds).round();
      for (var i = 0; i < sampleCount; i++) {
        final time = i / sampleRate;
        final attack = math.min(1.0, time / 0.012);
        final remaining = tone.durationSeconds - time;
        final release = math.min(1.0, math.max(0, remaining) / 0.055);
        final envelope = attack * release;
        final fundamental = math.sin(2 * math.pi * tone.frequency * time);
        final harmonic = 0.18 * math.sin(4 * math.pi * tone.frequency * time);
        final value = ((fundamental + harmonic) * envelope * 0.22).clamp(
          -1.0,
          1.0,
        );
        samples.add((value * 32767).round());
      }
      samples.addAll(List.filled((sampleRate * tone.gapSeconds).round(), 0));
    }

    final dataLength = samples.length * bytesPerSample;
    final bytes = ByteData(44 + dataLength);

    void ascii(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        bytes.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    ascii(0, 'RIFF');
    bytes.setUint32(4, 36 + dataLength, Endian.little);
    ascii(8, 'WAVE');
    ascii(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, 1, Endian.little);
    bytes.setUint32(24, sampleRate, Endian.little);
    bytes.setUint32(28, sampleRate * bytesPerSample, Endian.little);
    bytes.setUint16(32, bytesPerSample, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    ascii(36, 'data');
    bytes.setUint32(40, dataLength, Endian.little);

    for (var i = 0; i < samples.length; i++) {
      bytes.setInt16(44 + i * bytesPerSample, samples[i], Endian.little);
    }

    return bytes.buffer.asUint8List();
  }
}

class _Tone {
  const _Tone(this.frequency, this.durationSeconds, {this.gapSeconds = 0});

  final double frequency;
  final double durationSeconds;
  final double gapSeconds;
}
