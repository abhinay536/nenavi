import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';
import 'package:nenavi/widgets/assessment_timer.dart';

class CalculationScreen extends StatefulWidget {
  final String language;
  final DateTime endTime;
  final Function(int score) onComplete;

  const CalculationScreen({
    super.key,
    required this.language,
    required this.endTime,
    required this.onComplete,
  });

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  int _score = 0;
  int _step = 0; // 0 = first question, 1 = follow-up
  late String _questionText;
  late int _correctAnswer;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data =
        QuestionBank.mathProblems[widget.language] ??
        QuestionBank.mathProblems['en']!;
    _questionText = data['problem'];
    _correctAnswer = data['correctAnswer'];
  }

  void _submit() {
    int userAnswer = int.tryParse(_controller.text) ?? -1;
    if (userAnswer == _correctAnswer) _score++;
    if (_step == 0) {
      // Move to follow-up
      final data =
          QuestionBank.mathProblems[widget.language] ??
          QuestionBank.mathProblems['en']!;
      setState(() {
        _step = 1;
        _questionText = data['followUpProblem'];
        _correctAnswer = data['followUpAnswer'];
        _controller.clear();
      });
    } else {
      widget.onComplete(_score);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    TtsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Check'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AssessmentTimer(
              endTime: widget.endTime,
              onExpire: () {
                if (mounted) widget.onComplete(_score);
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  _questionText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: PlayAudioButton(
                  textToRead: _questionText,
                  language: widget.language,
                  label: 'Read Question',
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Your answer',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
