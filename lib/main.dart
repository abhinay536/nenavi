import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/caregiver_home_screen.dart';
import 'screens/caregiver_patients_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NenaviApp());
}

class NenaviApp extends StatelessWidget {
  const NenaviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nenavi',
      debugShowCheckedModeBanner: false,
      theme: NenaviTheme.theme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/patient_home': (context) => const HomeScreen(),
        '/caregiver_home': (context) => const CaregiverHomeScreen(),
        '/caregiver_patients': (context) => const CaregiverPatientsScreen(),
      },
      // Fallback on unknown route to login
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
class NenaviTheme {
  // Brand colours
  static const Color background = Color(0xFFE9DBC3);
  static const Color primary    = Color(0xFFFA7014);
  static const Color secondary  = Color(0xFFB67549);
  static const Color accent     = Color(0xFF371F0B);
  static const Color textDark   = Color(0xFF000000);
  static const Color cardBg     = Color(0xFFF5EDE0);
  static const Color errorRed   = Color(0xFFB00020);

  // Shared text styles (Palatino Linotype, elder-friendly sizes)
  static const String _font = 'Georgia'; // fallback for Android; see note
  // Note: Palatino Linotype is not bundled in Android. We use Google Fonts
  // 'IM Fell English' as the closest available serif, or fallback to Georgia.
  // To use true Palatino: add google_fonts package and replace with
  // GoogleFonts.imFellEnglish(). Using 'Georgia' here as safe fallback.

  static TextStyle heading({Color color = textDark}) => TextStyle(
    fontFamily: _font, fontSize: 28, fontWeight: FontWeight.bold,
    color: color, height: 1.3,
  );
  static TextStyle subheading({Color color = textDark}) => TextStyle(
    fontFamily: _font, fontSize: 22, fontWeight: FontWeight.w600,
    color: color, height: 1.3,
  );
  static TextStyle body({Color color = textDark}) => TextStyle(
    fontFamily: _font, fontSize: 18, color: color, height: 1.5,
  );
  static TextStyle label({Color color = accent}) => TextStyle(
    fontFamily: _font, fontSize: 16, color: color,
    fontWeight: FontWeight.w600, letterSpacing: 0.4,
  );
  static TextStyle small({Color color = accent}) => TextStyle(
    fontFamily: _font, fontSize: 14, color: color,
  );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: cardBg,
      error: errorRed,
      onPrimary: Colors.white,
      onSurface: textDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _font, fontSize: 22,
        fontWeight: FontWeight.bold, color: Colors.white,
      ),
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: TextStyle(
          fontFamily: _font, fontSize: 20, fontWeight: FontWeight.bold,
        ),
        elevation: 3,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondary,
        textStyle: TextStyle(
          fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.85),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      labelStyle: TextStyle(
        fontFamily: _font, fontSize: 17, color: accent,
      ),
      hintStyle: TextStyle(
        fontFamily: _font, fontSize: 16, color: Colors.grey.shade500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary.withOpacity(0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary.withOpacity(0.4), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(fontFamily: _font, fontSize: 18),
    ),
  );
}

// ── Reusable widgets ─────────────────────────────────────────────────────────

/// Warm-toned page scaffold with consistent padding
class NenaviPage extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const NenaviPage({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  });
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    padding: padding,
    child: child,
  );
}

/// Branded error box
class NenaviError extends StatelessWidget {
  final String message;
  const NenaviError(this.message, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEDED),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: NenaviTheme.errorRed.withOpacity(0.5)),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline, color: NenaviTheme.errorRed, size: 26),
      const SizedBox(width: 10),
      Expanded(child: Text(message, style: NenaviTheme.body(color: NenaviTheme.errorRed))),
    ]),
  );
}

/// Score colour helper
Color scoreColor(int score) {
  if (score >= 80) return const Color(0xFFD4EDDA);
  if (score >= 50) return const Color(0xFFFFF3CD);
  return const Color(0xFFFFDDD8);
}
Color scoreTextColor(int score) {
  if (score >= 80) return const Color(0xFF155724);
  if (score >= 50) return const Color(0xFF856404);
  return const Color(0xFF842029);
}
