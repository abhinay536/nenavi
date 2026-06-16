import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';

class AttentionTaskScreen extends StatefulWidget {
  final String language;
  final Function(int score, String seedPhrase, String enteredNumber) onComplete;

  const AttentionTaskScreen({
    super.key,
    required this.language,
    required this.onComplete,
  });

  @override
  State<AttentionTaskScreen> createState() => _AttentionTaskScreenState();
}

class _AttentionTaskScreenState extends State<AttentionTaskScreen> {
  int _step = 0; // 0: show seed phrase, 1: fruit task, 2: number task
  int _totalScore = 0;

  late String _seedPhraseInstruction;
  late String _seedPhrase;
  late String _fruitInstruction;
  late List<String> _fruitOptions;
  late List<String> _correctFruits;
  final Set<String> _selectedFruits = {};
  late String _numberInstruction;
  late String _targetNumber;
  String _enteredNumber = '';
  bool _numberFirstAttempt = true;

  @override
  void initState() {
    super.initState();
    final lang = widget.language;

    final seedData =
        QuestionBank.seedPhrase[lang] ?? QuestionBank.seedPhrase['en']!;
    _seedPhraseInstruction = seedData['instruction'];
    _seedPhrase = seedData['phrase'];

    final fruitData =
        QuestionBank.fruitTask[lang] ?? QuestionBank.fruitTask['en']!;
    _fruitInstruction = fruitData['instruction'];
    _fruitOptions = List<String>.from(fruitData['options']);
    _correctFruits = List<String>.from(fruitData['correct']);

    final numberData =
        QuestionBank.numberMemory[lang] ?? QuestionBank.numberMemory['en']!;
    _numberInstruction = numberData['instruction'];
    _targetNumber = numberData['targetNumber'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attention Check')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _step == 0
            ? _buildSeedPhrase()
            : (_step == 1 ? _buildFruitTask() : _buildNumberTask()),
      ),
    );
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  Widget _buildSeedPhrase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpeakableText(
          text: _seedPhraseInstruction,
          language: widget.language,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        SpeakableText(
          text: _seedPhrase,
          language: widget.language,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => setState(() => _step = 1),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildFruitTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpeakableText(
          text: _fruitInstruction,
          language: widget.language,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ..._fruitOptions.map((word) {
          final isSelected = _selectedFruits.contains(word);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SpeakableOptionButton(
              text: word,
              language: widget.language,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green.shade300 : null,
              ),
              onPressed: () {
                setState(() {
                  if (isSelected) {
                    _selectedFruits.remove(word);
                  } else {
                    _selectedFruits.add(word);
                  }
                });
              },
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _selectedFruits.isNotEmpty
              ? () {
                  final correct =
                      _selectedFruits.length == _correctFruits.length &&
                      _selectedFruits.every((w) => _correctFruits.contains(w));
                  if (correct) {
                    _totalScore++;
                  }
                  setState(() => _step = 2);
                }
              : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildNumberTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpeakableText(
          text: _numberInstruction,
          language: widget.language,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (v) => _enteredNumber = v,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Type the number',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_enteredNumber.trim() == _targetNumber) {
              if (_numberFirstAttempt) {
                _totalScore++;
              }
              widget.onComplete(
                _totalScore,
                _seedPhrase,
                _enteredNumber.trim(),
              );
            } else {
              setState(() => _numberFirstAttempt = false);
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
}
