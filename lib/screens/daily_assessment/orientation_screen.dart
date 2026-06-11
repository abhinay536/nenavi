import 'package:flutter/material.dart';

class OrientationScreen extends StatefulWidget {
  final String language; // kept for future use
  final Function(int score) onComplete;
  const OrientationScreen({
    super.key,
    required this.language,
    required this.onComplete,
  });

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  int _score = 0;
  int _questionIndex = 0;
  final List<String> _questions = [
    'What month is this?',
    'What year is this?',
    'What day of the week is today?',
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orientation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _questions[_questionIndex],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your answer',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                bool isCorrect = false;
                if (_questionIndex == 0) {
                  isCorrect =
                      _controller.text.trim().toLowerCase() ==
                      _getCurrentMonth().toLowerCase();
                } else if (_questionIndex == 1) {
                  isCorrect = _controller.text.trim() == now.year.toString();
                } else {
                  isCorrect =
                      _controller.text.trim().toLowerCase() ==
                      _getCurrentWeekday().toLowerCase();
                }
                if (isCorrect) _score++;
                if (_questionIndex + 1 < _questions.length) {
                  setState(() {
                    _questionIndex++;
                    _controller.clear();
                  });
                } else {
                  widget.onComplete(_score);
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentMonth() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[DateTime.now().month - 1];
  }

  String _getCurrentWeekday() {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[DateTime.now().weekday - 1];
  }
}
