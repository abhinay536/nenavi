import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';

class CalculationScreen extends StatefulWidget {
  final String language;
  final Function(int score) onComplete;

  const CalculationScreen({
    super.key,
    required this.language,
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
      appBar: AppBar(title: const Text('Calculation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpeakableText(
              text: _questionText,
              language: widget.language,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your answer',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}
