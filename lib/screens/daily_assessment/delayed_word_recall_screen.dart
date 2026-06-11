import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';

class DelayedWordRecallScreen extends StatefulWidget {
  final String language;
  final List<String> originalWords;
  final Function(int score) onComplete;

  const DelayedWordRecallScreen({
    super.key,
    required this.language,
    required this.originalWords,
    required this.onComplete,
  });

  @override
  State<DelayedWordRecallScreen> createState() =>
      _DelayedWordRecallScreenState();
}

class _DelayedWordRecallScreenState extends State<DelayedWordRecallScreen> {
  late List<String> _allWords;
  late Set<String> _selectedWords;
  late String _instruction;

  @override
  void initState() {
    super.initState();
    final data =
        QuestionBank.wordRecall[widget.language] ??
        QuestionBank.wordRecall['en']!;
    final distractors = List<String>.from(data['distractors']);
    _allWords = [...widget.originalWords, ...distractors];
    _allWords.shuffle();
    _selectedWords = {};
    _instruction = 'Select the 5 words you remember from earlier:';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recall Words')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_instruction, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                ),
                itemCount: _allWords.length,
                itemBuilder: (ctx, index) {
                  final word = _allWords[index];
                  final isSelected = _selectedWords.contains(word);
                  return Card(
                    color: isSelected ? Colors.green.shade100 : null,
                    child: ListTile(
                      title: Text(word),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedWords.remove(word);
                          } else if (_selectedWords.length < 5) {
                            _selectedWords.add(word);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _selectedWords.length == 5
                  ? () {
                      int correctCount = _selectedWords
                          .where((w) => widget.originalWords.contains(w))
                          .length;
                      widget.onComplete(
                        correctCount,
                      ); // this callback will pop the screen
                      // DO NOT call Navigator.pop(context) here
                    }
                  : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
