import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';
import 'package:nenavi/widgets/assessment_timer.dart';

class AttentionTaskScreen extends StatefulWidget {
  final String language;
  final DateTime endTime;
  final Function(int score, String seedPhrase, String enteredNumber) onComplete;

  const AttentionTaskScreen({
    super.key,
    required this.language,
    required this.endTime,
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
      appBar: AppBar(
        title: const Text('Attention Check'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AssessmentTimer(
              endTime: widget.endTime,
              onExpire: () {
                if (mounted)
                  Navigator.pop(context, [
                    _totalScore,
                    _seedPhrase,
                    _enteredNumber,
                  ]);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _step == 0
              ? _buildSeedPhrase()
              : (_step == 1 ? _buildFruitTask() : _buildNumberTask()),
        ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _seedPhraseInstruction,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Center(
          child: PlayAudioButton(
            textToRead: '$_seedPhraseInstruction. $_seedPhrase',
            language: widget.language,
            label: 'Read Aloud',
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            _seedPhrase,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => setState(() => _step = 1),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildFruitTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _fruitInstruction,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            PlayAudioButton(
              textToRead: _fruitInstruction,
              language: widget.language,
              label: 'Read Question',
            ),
            PlayAudioButton(
              textToRead: _fruitOptions.join(', '),
              language: widget.language,
              label: 'Read Options',
            ),
          ],
        ),
        const SizedBox(height: 32),
        ..._fruitOptions.map((word) {
          final isSelected = _selectedFruits.contains(word);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? Colors.green.shade400
                    : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                elevation: isSelected ? 2 : 1,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.green.shade600
                        : Colors.grey.shade300,
                  ),
                ),
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
              child: Text(
                word,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _numberInstruction,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Center(
          child: PlayAudioButton(
            textToRead: _numberInstruction,
            language: widget.language,
            label: 'Read Question',
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          onChanged: (v) => _enteredNumber = v,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            labelText: 'Type the number',
            alignLabelWithHint: true,
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
