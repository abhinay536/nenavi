import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nenavi/main.dart';

void main() {
  test('score helpers return the expected bands', () {
    expect(scoreColor(80), const Color(0xFFD4EDDA));
    expect(scoreColor(50), const Color(0xFFFFF3CD));
    expect(scoreColor(49), const Color(0xFFFFDDD8));

    expect(scoreTextColor(80), const Color(0xFF155724));
    expect(scoreTextColor(50), const Color(0xFF856404));
    expect(scoreTextColor(49), const Color(0xFF842029));
  });
}
