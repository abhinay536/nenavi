import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';

class WordRecallEncodingScreen extends StatefulWidget {
  final String language;
  final Function(List<String> words) onComplete;

  const WordRecallEncodingScreen({
    super.key,
    required this.language,
    required this.onComplete,
  });

  @override
  State<WordRecallEncodingScreen> createState() =>
      _WordRecallEncodingScreenState();
}

class _WordRecallEncodingScreenState extends State<WordRecallEncodingScreen> {
  late List<String> _wordsToRemember;
  late String _instruction;

  @override
  void initState() {
    super.initState();
    final data = QuestionBank.wordRecall[widget.language];
    if (data == null) {
      final fallback = QuestionBank.wordRecall['en']!;
      _wordsToRemember = List<String>.from(fallback['wordsToRemember']);
      _instruction = fallback['instruction'];
    } else {
      _wordsToRemember = List<String>.from(data['wordsToRemember']);
      _instruction = data['instruction'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remember These Words')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_instruction, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            const Text(
              'Words to remember:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._wordsToRemember.map(
              (word) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('• $word', style: const TextStyle(fontSize: 20)),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                widget.onComplete(_wordsToRemember); // callback pops the screen
              },
              child: const Text('I have remembered them'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
