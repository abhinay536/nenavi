import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;
  String _error = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // After login, check the user's role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!userDoc.exists) {
        setState(
          () => _error = 'User profile not found. Please register again.',
        );
        return;
      }

      final data = userDoc.data() as Map<String, dynamic>?;
      if (data == null) {
        setState(() => _error = 'User data is empty. Please register again.');
        return;
      }

      String? role = data['role'] as String?;
      if (role == null) {
        setState(() => _error = 'User role not set. Please register again.');
        return;
      }

      if (role == 'patient') {
        if (mounted) Navigator.pushReplacementNamed(context, '/patient_home');
      } else if (role == 'caregiver') {
        if (mounted) Navigator.pushReplacementNamed(context, '/caregiver_home');
      } else {
        setState(() => _error = 'Unknown role: $role');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Login failed');
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NenaviTheme.background,
      body: SafeArea(
        child: NenaviPage(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // ── Brand ──────────────────────────────────────────────
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: NenaviTheme.accent,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text('Nenavi',
                    style: NenaviTheme.heading()
                        .copyWith(fontSize: 36, color: NenaviTheme.accent)),
              ),
              Center(
                child: Text('Memory Care Companion',
                    style: NenaviTheme.body(color: NenaviTheme.secondary)),
              ),
              const SizedBox(height: 40),

              // ── Email ──────────────────────────────────────────────
              Text('Email', style: NenaviTheme.label()),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: NenaviTheme.body(),
                decoration: const InputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 20),

              // ── Password ───────────────────────────────────────────
              Text('Password', style: NenaviTheme.label()),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                style: NenaviTheme.body(),
                decoration: InputDecoration(
                  hintText: '••••••',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Error ──────────────────────────────────────────────
              if (_error.isNotEmpty) NenaviError(_error),

              // ── Sign in button ─────────────────────────────────────
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _login,
                      icon: const Icon(Icons.login, size: 24),
                      label: const Text('Sign In'),
                    ),
              const SizedBox(height: 16),

              // ── Register link ──────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: RichText(
                    text: TextSpan(
                      style: NenaviTheme.body(color: NenaviTheme.accent),
                      children: const [
                        TextSpan(text: 'New here? '),
                        TextSpan(
                          text: 'Create an account',
                          style: TextStyle(
                            color: NenaviTheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
