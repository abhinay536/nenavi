import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/daily_assessment/attention_task_screen.dart';
import 'screens/daily_assessment/word_recall_encoding_screen.dart';
import 'screens/daily_assessment/orientation_screen.dart';
import 'screens/daily_assessment/delayed_word_recall_screen.dart';
import 'screens/daily_assessment/calculation_screen.dart';
import 'services/database_helper.dart';
import 'dart:convert';
import 'screens/daily_assessment/incidental_memory_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _language = 'kn';
  int? _lastCompositeScore;
  String? _lastDate;
  bool _isAssessing = false;

  @override
  void initState() {
    super.initState();
    _loadLanguageAndLastScore();
  }

  Future<void> _loadLanguageAndLastScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _language = prefs.getString('language') ?? 'kn');
    final latest = await DatabaseHelper().getLatestScore();
    if (!mounted) return;
    if (latest != null) {
      setState(() {
        _lastCompositeScore = latest['composite_score'] as int?;
        _lastDate = latest['date'] as String?;
      });
    }
  }

  Future<void> _startAssessment() async {
    if (_isAssessing) return;
    setState(() => _isAssessing = true);

    try {
      // ── 1. Attention task ──────────────────────────────────────
      // Shows seed phrase → fruit picking → number press
      // Returns [score, seedPhrase, enteredNumber]
      final attentionResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => AttentionTaskScreen(
            language: _language,
            onComplete: (score, seedPhrase, enteredNumber) =>
                Navigator.pop(ctx, [score, seedPhrase, enteredNumber]),
          ),
        ),
      );
      if (!mounted) return;
      if (attentionResult == null) return;
      final attentionList = attentionResult as List;
      final attentionScore = attentionList[0] as int;
      final seedPhrase = attentionList[1] as String;
      // enteredNumber carried forward if needed for other tasks
      // final enteredNumber = attentionList[2] as String;

      // ── 2. Word recall encoding ────────────────────────────────
      final encodedWords = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => WordRecallEncodingScreen(
            language: _language,
            onComplete: (w) => Navigator.pop(ctx, w),
          ),
        ),
      ) as List<String>?;
      if (!mounted) return;
      if (encodedWords == null) return;

      // ── 3. Incidental memory: recall the seed phrase ───────────
      final incidentalScore = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => IncidentalMemoryScreen(
            language: _language,
            seedPhrase: seedPhrase,
            onComplete: (s) => Navigator.pop(ctx, s),
          ),
        ),
      ) as int?;
      if (!mounted) return;
      if (incidentalScore == null) return;

      // ── 4. Orientation ─────────────────────────────────────────
      final orientationScore = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => OrientationScreen(
            language: _language,
            onComplete: (s) => Navigator.pop(ctx, s),
          ),
        ),
      ) as int?;
      if (!mounted) return;
      if (orientationScore == null) return;

      // ── 5. Calculation ─────────────────────────────────────────
      final calculationScore = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => CalculationScreen(
            language: _language,
            onComplete: (s) => Navigator.pop(ctx, s),
          ),
        ),
      ) as int?;
      if (!mounted) return;
      if (calculationScore == null) return;

      // ── 6. Delayed word recall ─────────────────────────────────
      final delayedScore = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => DelayedWordRecallScreen(
            language: _language,
            originalWords: encodedWords,
            onComplete: (s) => Navigator.pop(ctx, s),
          ),
        ),
      ) as int?;
      if (!mounted) return;
      if (delayedScore == null) return;

      // ── Compute and save ───────────────────────────────────────
      // Max scores: attention=2, incidental=1, orientation=4, calculation=2, delayed=5 → total=14
      const int maxTotal = 14;
      final total = attentionScore +
          incidentalScore +
          orientationScore +
          calculationScore +
          delayedScore;
      final composite = (total * 100) ~/ maxTotal;
      final today = DateTime.now().toIso8601String().split('T')[0];

      final domainScoresMap = {
        'attention': attentionScore,
        'incidental_memory': incidentalScore,
        'orientation': orientationScore,
        'calculation': calculationScore,
        'delayed_recall': delayedScore,
      };

      await DatabaseHelper().insertScore({
        'date': today,
        'composite_score': composite,
        'domain_scores': jsonEncode(domainScoresMap),
        'difficulty': 'Basic',
      });

      if (!mounted) return;
      await _loadLanguageAndLastScore();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assessment saved! Score: $composite/100')),
      );
    } catch (e, stack) {
      debugPrint('Error: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isAssessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nenavi Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_lastCompositeScore != null)
              Text('Last score: $_lastCompositeScore/100 on $_lastDate'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAssessing ? null : _startAssessment,
              child: _isAssessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Start Daily Assessment'),
            ),
          ],
        ),
      ),
    );
  }
}
