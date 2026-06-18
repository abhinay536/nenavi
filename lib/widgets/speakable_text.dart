import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();

  static final FlutterTts _tts = FlutterTts();
  static String? _configuredLocale;

  static bool supportsLanguage(String language) {
    return language == 'en' || language == 'kn' || language == 'tcy';
  }

  static String _localeFor(String language) {
    if (language == 'kn' || language == 'tcy') return 'kn-IN';
    return 'en-US';
  }

  static Future<void> speak(String text, String language) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || !supportsLanguage(language)) return;

    try {
      final locale = _localeFor(language);
      if (_configuredLocale != locale) {
        await _tts.setLanguage(locale);
        await _tts.setSpeechRate(0.45);
        await _tts.setVolume(1.0);
        await _tts.setPitch(1.0);
        _configuredLocale = locale;
      }

      await _tts.stop();
      await _tts.speak(trimmed);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }
}

class PlayAudioButton extends StatelessWidget {
  final String textToRead;
  final String language;
  final String label;

  const PlayAudioButton({
    super.key,
    required this.textToRead,
    required this.language,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (!TtsService.supportsLanguage(language)) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue.shade200),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      icon: const Icon(Icons.volume_up_rounded, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onPressed: () => TtsService.speak(textToRead, language),
    );
  }
}
