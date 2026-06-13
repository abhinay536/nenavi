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
