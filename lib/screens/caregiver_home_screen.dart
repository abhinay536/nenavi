import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_history_screen.dart';
import '../main.dart';

class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});
  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() { super.initState(); _future = _load(); }

  Future<List<Map<String, dynamic>>> _load() async {
    final cg = FirebaseAuth.instance.currentUser;
    if (cg == null) return [];

    // Accept pending links
    try {
      final pending = await FirebaseFirestore.instance
          .collection('pending_patient_links')
          .where('caregiverUid', isEqualTo: cg.uid)
          .where('status', isEqualTo: 'pending')
          .get().timeout(const Duration(seconds: 15));

      for (final doc in pending.docs) {
        final d = doc.data();
        final pUid   = d['patientUid'] as String?;
        final pEmail = d['patientEmail'] as String?;
        if (pUid == null || pEmail == null) continue;
        await FirebaseFirestore.instance
            .collection('users').doc(cg.uid).collection('patients').doc(pUid)
            .set({'patientEmail': pEmail, 'patientUid': pUid,
                  'linkedAt': d['linkedAt'] ?? FieldValue.serverTimestamp()});
        await doc.reference.update({'status': 'accepted'});
      }
    } catch (e) { debugPrint('Pending link error: $e'); }

    // Fetch patients + scores
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users').doc(cg.uid).collection('patients')
          .get().timeout(const Duration(seconds: 20));

      final List<Map<String, dynamic>> result = [];
      for (final pd in snap.docs) {
        final d       = pd.data();
        final pUid    = d['patientUid'] as String?;
        final pEmail  = d['patientEmail'] as String? ?? 'Unknown';
        if (pUid == null || pUid.isEmpty) continue;

        int score = 0; String date = 'No data yet';
        try {
          final scores = await FirebaseFirestore.instance
              .collection('scores')
              .where('patientUid', isEqualTo: pUid)
              .orderBy('date', descending: true).limit(1)
              .get().timeout(const Duration(seconds: 15));
          if (scores.docs.isNotEmpty) {
            final sd = scores.docs.first.data();
            score = (sd['compositeScore'] as num?)?.toInt() ?? 0;
            date  = sd['date'] as String? ?? 'Unknown';
          }
        } catch (e) { debugPrint('Score fetch error: $e'); }

        result.add({'uid': pUid, 'email': pEmail, 'score': score, 'date': date});
      }
      return result;
    } catch (e) { debugPrint('Patients error: $e'); return []; }
  }

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NenaviTheme.background,
      appBar: AppBar(
        title: const Text('Caregiver Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), tooltip: 'Refresh', onPressed: _refresh),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              NenaviError('Failed to load patients.'),
              ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again')),
            ]));
          }

          final patients = snap.data ?? [];
          if (patients.isEmpty) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.people_outline, size: 72, color: NenaviTheme.secondary),
                const SizedBox(height: 20),
                Text('No patients linked yet.',
                    style: NenaviTheme.subheading(color: NenaviTheme.accent),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text('Ask your patients to register using your email address.',
                    style: NenaviTheme.body(color: NenaviTheme.secondary),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh')),
              ]),
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: patients.length,
            itemBuilder: (ctx, i) {
              final p     = patients[i];
              final score = p['score'] as int? ?? 0;
              return _PatientCard(
                email: p['email'] as String,
                score: score,
                date: p['date'] as String,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => PatientHistoryScreen(patientUid: p['uid']),
                )).then((_) => _refresh()),
              );
            },
          );
        },
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String email;
  final int score;
  final String date;
  final VoidCallback onTap;
  const _PatientCard({
    required this.email, required this.score,
    required this.date,  required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            // Score badge
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: scoreColor(score),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$score',
                    style: NenaviTheme.subheading(color: scoreTextColor(score))
                        .copyWith(fontSize: 22)),
                Text('/100',
                    style: NenaviTheme.small(color: scoreTextColor(score))),
              ]),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email,
                    style: NenaviTheme.body(color: NenaviTheme.accent)
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('Last tested: $date',
                    style: NenaviTheme.small(color: NenaviTheme.secondary)),
              ],
            )),
            const Icon(Icons.chevron_right_rounded,
                color: NenaviTheme.secondary, size: 30),
          ]),
        ),
      ),
    );
  }
}
