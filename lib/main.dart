import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const NenaviApp());
}

class NenaviApp extends StatelessWidget {
  const NenaviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nenavi',
      debugShowCheckedModeBanner: false, //  removes red banner
      home: const SplashScreen(),
    );
  }
}
