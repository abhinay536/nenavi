import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_selection_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Set this to false if you want to remember language between runs
  static const bool alwaysStartFresh = true;

  @override
  void initState() {
    super.initState();
    _checkLanguage();
  }

  Future<void> _checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? language;
    if (!alwaysStartFresh) {
      language = prefs.getString('language');
    }
    // Optional delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (language == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Nenavi\nLoading...', textAlign: TextAlign.center),
      ),
    );
  }
}
