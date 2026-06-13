import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_history_screen.dart';

class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  late Future<List<Map<String, dynamic>>> _patientDataFuture;

  @override
  void initState() {
    super.initState();
    _patientDataFuture = _fetchPatientsWithLatestScores();
  }

  Future<List<Map<String, dynamic>>> _fetchPatientsWithLatestScores() async {
    final caregiver = FirebaseAuth.instance.currentUser;
    if (caregiver == null) return [];

    try {
      final patientsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(caregiver.uid)
          .collection('patients')
          .get()
          .timeout(const Duration(seconds: 20));

      final List<Map<String, dynamic>> patientsData = [];

      for (var patientDoc in patientsSnapshot.docs) {
        final patientData = patientDoc.data();
        final patientUid = patientData['patientUid'] as String?;
        final patientEmail = patientData['patientEmail'] as String? ?? 'Unknown';

        if (patientUid != null && patientUid.isNotEmpty) {
          // Fetch latest score for this patient
          try {
            final scoreSnapshot = await FirebaseFirestore.instance
                .collection('scores')
                .where('patientUid', isEqualTo: patientUid)
                .orderBy('date', descending: true)
                .limit(1)
                .get()
                .timeout(const Duration(seconds: 10));

            int latestScore = 0;
            String latestDate = 'No data';

            if (scoreSnapshot.docs.isNotEmpty) {
              final scoreData = scoreSnapshot.docs.first.data();
              latestScore = scoreData['compositeScore'] as int? ?? 0;
              latestDate = scoreData['date'] as String? ?? 'Unknown';
            }

            patientsData.add({
              'uid': patientUid,
              'email': patientEmail,
              'latestScore': latestScore,
              'latestDate': latestDate,
            });
          } catch (e) {
            debugPrint('Error fetching score for patient $patientUid: $e');
            patientsData.add({
              'uid': patientUid,
              'email': patientEmail,
              'latestScore': 0,
              'latestDate': 'Error loading',
            });
          }
        }
      }

      return patientsData;
    } catch (e) {
      debugPrint('Error fetching patients: $e');
      return [];
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green.shade100;
    if (score >= 50) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver Dashboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _patientDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final patients = snapshot.data ?? [];

          if (patients.isEmpty) {
            return const Center(
              child: Text(
                'No patients linked yet.\nPatients must register with your email.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: patients.length,
            itemBuilder: (ctx, index) {
              final patient = patients[index];
              final score = patient['latestScore'] as int? ?? 0;
              final cardColor = _getScoreColor(score);

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    patient['email'] ?? 'Unknown Patient',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Latest Score: $score/100'),
                      Text('Date: ${patient['latestDate']}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientHistoryScreen(
                          patientUid: patient['uid'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
