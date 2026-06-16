import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/daily_assessment/attention_task_screen.dart';
import 'screens/daily_assessment/word_recall_encoding_screen.dart';
import 'screens/daily_assessment/orientation_screen.dart';
import 'screens/daily_assessment/delayed_word_recall_screen.dart';
import 'screens/daily_assessment/calculation_screen.dart';
import 'screens/daily_assessment/incidental_memory_screen.dart';
import 'package:nenavi/screens/patient_history_screen.dart';
import 'services/database_helper.dart';
import 'main.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _language = 'kn';
  int? _lastScore;
  String? _lastDate;
  bool _isAssessing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final savedLanguage = prefs.getString('language');
    setState(() => _language = _supportedLanguage(savedLanguage));
    final user = FirebaseAuth.instance.currentUser;
    final latest = await DatabaseHelper().getLatestScore(patientUid: user?.uid);
    if (!mounted) return;
    if (latest != null) {
      setState(() {
        _lastScore = latest['composite_score'] as int?;
        _lastDate = latest['date'] as String?;
      });
    }
  }

  String _supportedLanguage(String? language) {
    return language == 'en' || language == 'kn' ? language! : 'kn';
  }

  Future<void> _setLanguage(String language) async {
    final selected = _supportedLanguage(language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', selected);
    if (!mounted) return;
    setState(() => _language = selected);
  }

  Future<void> _startAssessment() async {
    if (_isAssessing) return;
    setState(() => _isAssessing = true);
    try {
      final attResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => AttentionTaskScreen(
            language: _language,
            onComplete: (score, seed, enteredNumber) =>
                Navigator.pop(ctx, [score, seed, enteredNumber]),
          ),
        ),
      );
      if (!mounted || attResult == null) return;
      final attScore = (attResult as List)[0] as int;
      final seedPhrase = attResult[1] as String;

      final encodedWords =
          await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => WordRecallEncodingScreen(
                    language: _language,
                    onComplete: (w) => Navigator.pop(ctx, w),
                  ),
                ),
              )
              as List<String>?;
      if (!mounted || encodedWords == null) return;

      final incidentalScore =
          await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => IncidentalMemoryScreen(
                    language: _language,
                    seedPhrase: seedPhrase,
                    onComplete: (s) => Navigator.pop(ctx, s),
                  ),
                ),
              )
              as int?;
      if (!mounted || incidentalScore == null) return;

      final orientationScore =
          await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => OrientationScreen(
                    language: _language,
                    onComplete: (s) => Navigator.pop(ctx, s),
                  ),
                ),
              )
              as int?;
      if (!mounted || orientationScore == null) return;

      final calcScore =
          await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => CalculationScreen(
                    language: _language,
                    onComplete: (s) => Navigator.pop(ctx, s),
                  ),
                ),
              )
              as int?;
      if (!mounted || calcScore == null) return;

      final delayedScore =
          await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => DelayedWordRecallScreen(
                    language: _language,
                    originalWords: encodedWords,
                    onComplete: (s) => Navigator.pop(ctx, s),
                  ),
                ),
              )
              as int?;
      if (!mounted || delayedScore == null) return;

      const int maxTotal = 14;
      final total =
          attScore +
          incidentalScore +
          orientationScore +
          calcScore +
          delayedScore;
      final composite = (total * 100) ~/ maxTotal;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final domainMap = {
        'attention': attScore,
        'incidental_memory': incidentalScore,
        'orientation': orientationScore,
        'calculation': calcScore,
        'delayed_recall': delayedScore,
      };
      final user = FirebaseAuth.instance.currentUser;

      await DatabaseHelper().insertScore({
        'date': today,
        'composite_score': composite,
        'domain_scores': jsonEncode(domainMap),
        'difficulty': 'Basic',
        'patient_uid': user?.uid,
      });

      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('scores')
              .doc('${user.uid}_$today')
              .set({
                'patientUid': user.uid,
                'date': today,
                'compositeScore': composite,
                'domainScores': domainMap,
                'difficulty': 'Basic',
                'timestamp': FieldValue.serverTimestamp(),
              });
        } catch (e) {
          debugPrint('Firestore save error: $e');
        }
      }

      if (!mounted) return;
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assessment complete! Score: $composite / 100'),
          backgroundColor: NenaviTheme.secondary,
        ),
      );
    } catch (e, s) {
      debugPrint('Error: $e\n$s');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAssessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: NenaviTheme.background,
      appBar: AppBar(
        title: const Text('My Dashboard'),
        actions: [
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
      body: NenaviPage(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Greeting ──────────────────────────────────────────────
            Text(
              'Good day!',
              style: NenaviTheme.heading(color: NenaviTheme.accent),
            ),
            Text(
              user?.email ?? '',
              style: NenaviTheme.body(color: NenaviTheme.secondary),
            ),
            const SizedBox(height: 28),

            // ── Last score card ────────────────────────────────────────
            if (_lastScore != null) ...[
              _ScoreCard(score: _lastScore!, date: _lastDate ?? ''),
              const SizedBox(height: 28),
            ],

            _LanguageCard(
              selectedLanguage: _language,
              onChanged: _isAssessing ? null : _setLanguage,
            ),
            const SizedBox(height: 16),

            // ── Start assessment ───────────────────────────────────────
            _BigActionCard(
              icon: Icons.assignment_outlined,
              title: 'Daily Assessment',
              subtitle:
                  'Takes about 5–10 minutes.\nDo it at the same time each day.',
              buttonLabel: _isAssessing
                  ? 'In progress…'
                  : 'Start Today\'s Test',
              onTap: _isAssessing ? null : _startAssessment,
              loading: _isAssessing,
            ),
            const SizedBox(height: 16),

            // ── View history ───────────────────────────────────────────
            _BigActionCard(
              icon: Icons.bar_chart_rounded,
              title: 'Score History',
              subtitle: 'See how you have been doing over time.',
              buttonLabel: 'View My Scores',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientHistoryScreen()),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String>? onChanged;

  const _LanguageCard({
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NenaviTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: NenaviTheme.accent.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Test Language',
            style: NenaviTheme.subheading(color: NenaviTheme.accent),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose before starting today\'s assessment.',
            style: NenaviTheme.body(
              color: NenaviTheme.secondary,
            ).copyWith(fontSize: 15),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'kn',
                label: Text('Kannada'),
                icon: Icon(Icons.translate),
              ),
              ButtonSegment(
                value: 'en',
                label: Text('English'),
                icon: Icon(Icons.language),
              ),
            ],
            selected: {selectedLanguage == 'en' ? 'en' : 'kn'},
            onSelectionChanged: onChanged == null
                ? null
                : (selection) => onChanged!(selection.first),
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  final String date;
  const _ScoreCard({required this.score, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scoreColor(score),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scoreTextColor(score).withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: scoreTextColor(score).withOpacity(0.15),
            child: Text(
              '$score',
              style: NenaviTheme.heading(
                color: scoreTextColor(score),
              ).copyWith(fontSize: 26),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Score',
                style: NenaviTheme.label(color: scoreTextColor(score)),
              ),
              Text(
                '$score / 100',
                style: NenaviTheme.subheading(color: scoreTextColor(score)),
              ),
              Text(
                date,
                style: NenaviTheme.small(color: scoreTextColor(score)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BigActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onTap;
  final bool loading;
  const _BigActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NenaviTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: NenaviTheme.accent.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NenaviTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: NenaviTheme.primary, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: NenaviTheme.subheading(color: NenaviTheme.accent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: NenaviTheme.body(
                        color: NenaviTheme.secondary,
                      ).copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(onPressed: onTap, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}
