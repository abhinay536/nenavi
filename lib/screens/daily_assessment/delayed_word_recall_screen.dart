import 'package:flutter/material.dart';
import 'package:nenavi/data/question_bank.dart';
import 'package:nenavi/widgets/speakable_text.dart';
import 'package:nenavi/widgets/assessment_timer.dart';

class DelayedWordRecallScreen extends StatefulWidget {
  final String language;
  final List<String> originalWords;
  final DateTime endTime;
  final Function(int score) onComplete;

  const DelayedWordRecallScreen({
    super.key,
    required this.language,
    required this.originalWords,
    required this.endTime,
    required this.onComplete,
  });

  @override
  State<DelayedWordRecallScreen> createState() =>
      _DelayedWordRecallScreenState();
}

class _DelayedWordRecallScreenState extends State<DelayedWordRecallScreen> {
  late List<String> _allWords;
  late Set<String> _selectedWords;

  static const Map<String, String> _instructions = {
    'kn': 'ನೀವು ಮೊದಲು ನೆನಪಿಟ್ಟುಕೊಂಡ 5 ಪದಗಳನ್ನು ಆಯ್ಕೆ ಮಾಡಿ:',
    'tcy': 'ಈರ್ ದುಂಬು ನೆಂಪು ಮಲ್ತಿನ 5 ಪದೊಕುಲೆನ್ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ:',
    'en': 'Select the 5 words you remembered from earlier:',
  };

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
  }

  @override
  Widget build(BuildContext context) {
    final instruction = _instructions[widget.language] ?? _instructions['en']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delayed Recall'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AssessmentTimer(
              endTime: widget.endTime,
              onExpire: () {
                final correct = _selectedWords
                    .where((w) => widget.originalWords.contains(w))
                    .length;
                if (mounted) widget.onComplete(correct);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              instruction,
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
                  textToRead: instruction,
                  language: widget.language,
                  label: 'Read Question',
                ),
                PlayAudioButton(
                  textToRead: _allWords.join(', '),
                  language: widget.language,
                  label: 'Read Options',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '${_selectedWords.length}/5 selected',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _allWords.length,
                itemBuilder: (ctx, index) {
                  final word = _allWords[index];
                  final isSelected = _selectedWords.contains(word);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedWords.remove(word);
                        } else if (_selectedWords.length < 5) {
                          _selectedWords.add(word);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green.shade400
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.green.shade600
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.green.shade100,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        word,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _selectedWords.length == 5
                    ? () {
                        final correct = _selectedWords
                            .where((w) => widget.originalWords.contains(w))
                            .length;
                        widget.onComplete(correct);
                      }
                    : null,
                child: const Text('Submit'),
              ),
            ),
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
