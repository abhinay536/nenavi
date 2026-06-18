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

class SpeakableText extends StatelessWidget {
  final String text;
  final String language;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SpeakableText({
    super.key,
    required this.text,
    required this.language,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if (!TtsService.supportsLanguage(language)) {
      return textWidget;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: textWidget),
        const SizedBox(width: 8),
        SpeakerButton(text: text, language: language),
      ],
    );
  }
}

class SpeakerButton extends StatelessWidget {
  final String text;
  final String language;

  const SpeakerButton({super.key, required this.text, required this.language});

  @override
  Widget build(BuildContext context) {
    if (!TtsService.supportsLanguage(language)) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.volume_up_outlined),
      tooltip: 'Speak',
      onPressed: () => TtsService.speak(text, language),
    );
  }
}

class SpeakableOptionButton extends StatelessWidget {
  final String text;
  final String language;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final TextAlign textAlign;

  const SpeakableOptionButton({
    super.key,
    required this.text,
    required this.language,
    required this.onPressed,
    this.style,
    this.textStyle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(text, style: textStyle, textAlign: textAlign),
    );

    if (!TtsService.supportsLanguage(language)) {
      return button;
    }

    return Row(
      children: [
        Expanded(child: button),
        const SizedBox(width: 8),
        SpeakerButton(text: text, language: language),
      ],
    );
  }
}
