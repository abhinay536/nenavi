import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import '../localization.dart';

class AssessmentTimer extends StatefulWidget {
  final DateTime endTime;
  final VoidCallback onExpire;

  const AssessmentTimer({
    super.key,
    required this.endTime,
    required this.onExpire,
  });

  @override
  State<AssessmentTimer> createState() => _AssessmentTimerState();
}

class _AssessmentTimerState extends State<AssessmentTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    if (now.isAfter(widget.endTime)) {
      _timer.cancel();
      if (mounted) {
        widget.onExpire();
      }
    } else {
      setState(() {
        _remaining = widget.endTime.difference(now);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool isWarning = _remaining.inMinutes < 2;
    
    return ValueListenableBuilder<String>(
      valueListenable: globalLanguage,
      builder: (context, lang, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isWarning ? Colors.red.shade100 : Colors.white24,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: isWarning ? Colors.red.shade900 : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${Localization.get('time_remaining', lang)}: ${_formatDuration(_remaining)}',
                style: TextStyle(
                  color: isWarning ? Colors.red.shade900 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
