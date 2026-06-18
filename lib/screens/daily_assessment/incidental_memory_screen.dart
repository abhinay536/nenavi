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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _instruction,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  PlayAudioButton(
                    textToRead: _instruction,
                    language: widget.language,
                    label: 'Read Question',
                  ),
                  PlayAudioButton(
                    textToRead: _options.join(', '),
                    language: widget.language,
                    label: 'Read Options',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ..._options.map((opt) {
                final isSelected = _selectedOption == opt;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.blue.shade400
                          : Colors.white,
                      foregroundColor: isSelected
                          ? Colors.white
                          : Colors.black87,
                      elevation: isSelected ? 2 : 1,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    onPressed: () => setState(() => _selectedOption = opt),
                    child: Text(
                      opt,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      ),
    );
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }
}
