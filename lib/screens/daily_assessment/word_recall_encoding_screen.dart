import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';
import 'package:nenavi/widgets/assessment_timer.dart';

class WordRecallEncodingScreen extends StatefulWidget {
  final String language;
  final DateTime endTime;
  final Function(List<String> words) onComplete;

  const WordRecallEncodingScreen({
    super.key,
    required this.language,
    required this.endTime,
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
    final data =
        QuestionBank.wordRecall[widget.language] ??
        QuestionBank.wordRecall['en']!;
    _wordsToRemember = List<String>.from(data['wordsToRemember']);
    _instruction = data['instruction'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Memory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AssessmentTimer(
              endTime: widget.endTime,
              onExpire: () {
                if (mounted) widget.onComplete(_wordsToRemember);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpeakableText(
              text: _instruction,
              language: widget.language,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ..._wordsToRemember.map(
              (word) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SpeakableText(
                  text: word,
                  language: widget.language,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onComplete(_wordsToRemember),
                child: const Text('I have remembered them'),
              ),
            ),
            const SizedBox(height: 20),
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
