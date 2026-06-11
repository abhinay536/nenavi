import 'package:flutter/material.dart';

class IncidentalMemoryScreen extends StatelessWidget {
  final String language;
  final String commandText;
  final String selectedWord;
  final String enteredNumber;
  final Function(int score) onComplete;

  const IncidentalMemoryScreen({
    super.key,
    required this.language,
    required this.commandText,
    required this.selectedWord,
    required this.enteredNumber,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Simple UI to test navigation
    return Scaffold(
      appBar: AppBar(title: const Text('Incidental Memory')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('What number did you enter earlier?'),
            const SizedBox(height: 20),
            TextField(
              onSubmitted: (value) {
                bool isCorrect = (value.trim() == enteredNumber);
                onComplete(isCorrect ? 1 : 0);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type the number',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
