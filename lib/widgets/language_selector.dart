import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalLanguage,
      builder: (context, lang, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NenaviTheme.secondary.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: lang,
              icon: const Icon(Icons.language, color: NenaviTheme.primary),
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(
                    'English',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DropdownMenuItem(
                  value: 'kn',
                  child: Text(
                    'ಕನ್ನಡ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DropdownMenuItem(
                  value: 'tcy',
                  child: Text(
                    'ತುಳು',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              onChanged: (String? newLang) async {
                if (newLang != null) {
                  globalLanguage.value = newLang;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('language', newLang);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
