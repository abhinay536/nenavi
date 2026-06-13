import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nenavi/screens/patient_history_screen.dart';

class CaregiverPatientsScreen extends StatefulWidget {
  const CaregiverPatientsScreen({super.key});

  @override
  State<CaregiverPatientsScreen> createState() =>
      _CaregiverPatientsScreenState();
}

class _CaregiverPatientsScreenState extends State<CaregiverPatientsScreen> {
  late Future<List<Map<String, String>>> _patientsFuture;

  @override
  void initState() {
    super.initState();
    _patientsFuture = _fetchPatients();
  }

  Future<List<Map<String, String>>> _fetchPatients() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('patients')
          .get()
          .timeout(const Duration(seconds: 20));
      return snapshot.docs.map((d) {
        final data = d.data();
        return {
          'uid': data['patientUid'] as String? ?? '',
          'email': data['patientEmail'] as String? ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching patients: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Patients')),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final patients = snapshot.data ?? [];
          if (patients.isEmpty)
            return const Center(child: Text('No patients found'));
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (ctx, i) {
              final p = patients[i];
              return ListTile(
                title: Text(p['email'] ?? 'Unknown'),
                subtitle: Text(p['uid'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PatientHistoryScreen(patientUid: p['uid']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
