import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';

class AttentionTaskScreen extends StatefulWidget {
  final String language;
  // score: fruit task (1) + number task (1) = max 2
  // seedPhrase: the phrase shown at the beginning (passed forward for incidental recall)
  final Function(int score, String seedPhrase, String enteredNumber) onComplete;

  const AttentionTaskScreen({
    super.key,
    required this.language,
    required this.onComplete,
  });

  @override
  State<AttentionTaskScreen> createState() => _AttentionTaskScreenState();
}

// Task steps:
//   0 = show seed phrase (read this)
//   1 = fruit picking task
//   2 = number press task
class _AttentionTaskScreenState extends State<AttentionTaskScreen> {
  int _step = 0;
  int _totalScore = 0;

  // Seed phrase data
  late String _seedPhraseInstruction;
  late String _seedPhrase;

  // Fruit task data
  late String _fruitInstruction;
  late List<String> _fruitOptions;
  late List<String> _correctFruits;
  final Set<String> _selectedFruits = {};

  // Number task data
  late String _numberInstruction;
  late String _targetNumber;
  String _enteredNumber = '';
  bool _numberFirstAttempt = true;
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final lang = widget.language;

    // Seed phrase
    final seedData =
        QuestionBank.seedPhrase[lang] ?? QuestionBank.seedPhrase['en']!;
    _seedPhraseInstruction = seedData['instruction'] as String;
    _seedPhrase = seedData['phrase'] as String;

    // Fruit task
    final fruitData =
        QuestionBank.fruitTask[lang] ?? QuestionBank.fruitTask['en']!;
    _fruitInstruction = fruitData['instruction'] as String;
    _fruitOptions = List<String>.from(fruitData['options']);
    _correctFruits = List<String>.from(fruitData['correct']);

    // Number task
    final numberData =
        QuestionBank.numberMemory[lang] ?? QuestionBank.numberMemory['en']!;
    _numberInstruction = numberData['instruction'] as String;
    _targetNumber = numberData['targetNumber'] as String;
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attention Check')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: () {
          switch (_step) {
            case 0:
              return _buildSeedPhrase();
            case 1:
              return _buildFruitTask();
            case 2:
              return _buildNumberTask();
            default:
              return const SizedBox.shrink();
          }
        }(),
      ),
    );
  }

  // ── Step 0: Show seed phrase ──────────────────────────────────
  Widget _buildSeedPhrase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_seedPhraseInstruction, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 30),
        Text(
          _seedPhrase,
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

  // ── Step 1: Fruit picking (multi-select) ──────────────────────
  Widget _buildFruitTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_fruitInstruction, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        ..._fruitOptions.map((word) {
          final isSelected = _selectedFruits.contains(word);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? Colors.green.shade300 : null,
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
              child: Text(word),
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _selectedFruits.isNotEmpty
              ? () {
                  // Score: 1 if all and only correct fruits selected
                  final correct =
                      _selectedFruits.length == _correctFruits.length &&
                      _selectedFruits
                          .every((w) => _correctFruits.contains(w));
                  if (correct) _totalScore++;
                  setState(() => _step = 2);
                }
              : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  // ── Step 2: Number press ──────────────────────────────────────
  Widget _buildNumberTask() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_numberInstruction, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        TextField(
          controller: _numberController,
          keyboardType: TextInputType.number,
          onChanged: (v) => _enteredNumber = v,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Type the number',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_enteredNumber.trim() == _targetNumber) {
              if (_numberFirstAttempt) _totalScore++;
              widget.onComplete(_totalScore, _seedPhrase, _enteredNumber.trim());
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
