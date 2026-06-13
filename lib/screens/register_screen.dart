import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'patient';
  final TextEditingController _caregiverEmailController =
      TextEditingController();
  bool _isLoading = false;
  String _error = '';

  Future<void> _register() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password required');
      }

      debugPrint('Register: creating user for $email');
      // 1. Create user in Firebase Auth (with timeout to avoid indefinite hang)
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw Exception('Auth request timed out');
      });
      final uid = userCredential.user!.uid;
      debugPrint('Register: created uid=$uid');

      // 2. Prepare user data for Firestore
      Map<String, dynamic> userData = {
        'email': email,
        'role': _role,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (_role == 'patient') {
        final caregiverEmail = _caregiverEmailController.text.trim();
        if (caregiverEmail.isEmpty) {
          throw Exception('Caregiver email required for patient');
        }
        userData['caregiverEmail'] = caregiverEmail;

        debugPrint('Register: looking up caregiver $caregiverEmail');
        // Check if caregiver exists and add patient to caregiver's subcollection
        final caregiverQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: caregiverEmail)
            .where('role', isEqualTo: 'caregiver')
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 20), onTimeout: () {
          throw Exception('Firestore caregiver lookup timed out');
        });

        if (caregiverQuery.docs.isEmpty) {
          throw Exception('Caregiver not found. Register caregiver first.');
        }

        final caregiverDoc = caregiverQuery.docs.first;
        await caregiverDoc.reference.collection('patients').doc(uid).set({
          'patientEmail': email,
          'patientUid': uid,
          'linkedAt': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 20), onTimeout: () {
          throw Exception('Firestore set timed out');
        });
      }

      debugPrint('Register: saving user doc');
      // 3. Save user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw Exception('Saving user doc timed out');
      });

      debugPrint('Register: saved user doc');

      // 4. Success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Register: FirebaseAuthException: ${e.message}');
      if (mounted) setState(() => _error = e.message ?? 'Auth error');
    } catch (e) {
      debugPrint('Register: Exception: $e');
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'patient', child: Text('Patient')),
                DropdownMenuItem(value: 'caregiver', child: Text('Caregiver')),
              ],
              onChanged: (value) => setState(() => _role = value!),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            if (_role == 'patient') ...[
              const SizedBox(height: 10),
              TextField(
                controller: _caregiverEmailController,
                decoration: const InputDecoration(labelText: 'Caregiver Email'),
              ),
            ],
            const SizedBox(height: 20),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
