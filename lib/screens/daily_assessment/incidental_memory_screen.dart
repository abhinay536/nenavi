import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';
import 'package:nenavi/widgets/assessment_timer.dart';

class IncidentalMemoryScreen extends StatefulWidget {
  final String language;
  final String seedPhrase;
  final DateTime endTime;
  final Function(int score) onComplete;

  const IncidentalMemoryScreen({
    super.key,
    required this.language,
    required this.seedPhrase,
    required this.endTime,
    required this.onComplete,
  });

  @override
  State<IncidentalMemoryScreen> createState() => _IncidentalMemoryScreenState();
}

class _IncidentalMemoryScreenState extends State<IncidentalMemoryScreen> {
  late String _instruction;
  late List<String> _options;
  late String _correctOption;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    final data =
        QuestionBank.phraseRecall[widget.language] ??
        QuestionBank.phraseRecall['en']!;
    _instruction = data['instruction'];
    _options = List<String>.from(data['options']);
    _correctOption = data['correct'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidental Memory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AssessmentTimer(
              endTime: widget.endTime,
              onExpire: () {
                final score = _selectedOption == _correctOption ? 1 : 0;
                if (mounted) widget.onComplete(score);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpeakableText(
              text: _instruction,
              language: widget.language,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ..._options.map(
              (opt) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SpeakableOptionButton(
                  text: opt,
                  language: widget.language,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOption == opt
                        ? Colors.blue.shade200
                        : null,
                  ),
                  onPressed: () => setState(() => _selectedOption = opt),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () => widget.onComplete(
                      _selectedOption == _correctOption ? 1 : 0,
                    ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }
}
