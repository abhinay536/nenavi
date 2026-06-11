import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';

class AttentionTaskScreen extends StatefulWidget {
  final String language;
  final Function(int score, String selectedWord, String enteredNumber)
  onComplete;

  const AttentionTaskScreen({
    super.key,
    required this.language,
    required this.onComplete,
  });

  @override
  State<AttentionTaskScreen> createState() => _AttentionTaskScreenState();
}

class _AttentionTaskScreenState extends State<AttentionTaskScreen> {
  int _taskIndex = 0;
  int _totalScore = 0;
  bool _firstAttempt = true;

  late String _instruction;
  late String _letter;
  late List<String> _options;
  late String _correctWord;
  late String _targetNumber;
  String _enteredNumber = '';

  @override
  void initState() {
    super.initState();
    final langData = QuestionBank.letterTask[widget.language];
    if (langData == null) {
      final fallback = QuestionBank.letterTask['en']!;
      _instruction = fallback['instruction'];
      _letter = fallback['letter'];
      _options = List<String>.from(fallback['options']);
      _correctWord = fallback['correct'];
    } else {
      _instruction = langData['instruction'];
      _letter = langData['letter'];
      _options = List<String>.from(langData['options']);
      _correctWord = langData['correct'];
    }
    final numberData = QuestionBank.numberMemory[widget.language];
    _targetNumber = numberData?['targetNumber'] ?? '1239';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attention Check')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _taskIndex == 0 ? _buildLetterTask() : _buildNumberTask(),
      ),
    );
  }

  Widget _buildLetterTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$_instruction "$_letter"'),
        const SizedBox(height: 20),
        ..._options.map(
          (word) => ElevatedButton(
            onPressed: () {
              if (word == _correctWord && _firstAttempt) _totalScore++;
              _moveToNextTask();
            },
            child: Text(word),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Enter the number: $_targetNumber'),
        const SizedBox(height: 20),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => _enteredNumber = value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Type the number',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_enteredNumber == _targetNumber) {
              if (_firstAttempt) _totalScore++;
              // Ensure we never pass null
              widget.onComplete(_totalScore, _correctWord, _enteredNumber);
            } else {
              setState(() => _firstAttempt = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Incorrect, try again')),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _moveToNextTask() {
    setState(() {
      _taskIndex++;
      _firstAttempt = true;
      _enteredNumber = '';
    });
  }
}
