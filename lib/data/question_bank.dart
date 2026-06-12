class QuestionBank {
  // ============================================================
  // 1. Statement Recall
  // ============================================================
  static const Map<String, Map<String, dynamic>> statementRecall = {
    'kn': {
      'statement': 'ನಾನು ಒಳ್ಳೆಯ ವ್ಯಕ್ತಿ.',
      'recallQuestion': 'ನೀವು ಆರಂಭದಲ್ಲಿ ಓದಿದ ವಾಕ್ಯವನ್ನು ಆರಿಸಿ',
      'options': [
        'DRINK WATER',
        'SING A SONG',
        'CLOSE YOUR EYES',
        'I AM A GOOD PERSON',
        'CLAP YOUR HANDS'
      ],
      'correct': 'I AM A GOOD PERSON',
    },
    'tcy': {
      'statement': 'ಯಾನ್ ಒರಿ ಎಡ್ಡೆ ವ್ಯಕ್ತಿ',
      'recallQuestion': 'ಈರ್ ದುಂಬು ಪಂತಿನ ವಾಕ್ಯೊನು ಇತ್ತೆ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
      'options': [
        'DRINK WATER',
        'SING A SONG',
        'CLOSE YOUR EYES',
        'I AM A GOOD PERSON',
        'CLAP YOUR HANDS'
      ],
      'correct': 'I AM A GOOD PERSON',
    },
    'en': {
      'statement': 'I AM A GOOD PERSON',
      'recallQuestion': 'SELECT THE PHRASE YOU READ EARLIER',
      'options': [
        'DRINK WATER',
        'SING A SONG',
        'CLOSE YOUR EYES',
        'I AM A GOOD PERSON',
        'CLAP YOUR HANDS'
      ],
      'correct': 'I AM A GOOD PERSON',
    },
  };

  // ============================================================
  // 2. Category Identification (Fruit Words)
  // ============================================================
  static const Map<String, Map<String, dynamic>> categoryTask = {
    'kn': {
      'instruction': 'ಹಣ್ಣಿನ ಪದಗಳನ್ನು ಆರಿಸಿ',
      'options': ['banana', 'church', 'orange', 'stapler'],
      'correct': ['banana', 'orange'],
    },
    'tcy': {
      'instruction': 'ಫಲ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
      'options': ['banana', 'church', 'orange', 'stapler'],
      'correct': ['banana', 'orange'],
    },
    'en': {
      'instruction': 'Pick the fruit words',
      'options': ['banana', 'church', 'orange', 'stapler'],
      'correct': ['banana', 'orange'],
    },
  };

  // ============================================================
  // 3. Number Memory
  // ============================================================
  static const Map<String, Map<String, dynamic>> numberMemory = {
    'kn': {
      'instruction': '1239 ಸಂಖ್ಯೆಯನ್ನು ನೆನಪಿಡಿ',
      'targetNumber': '1239',
      'recallInstruction': 'ನೀವು ಮೊದಲು ನೋಡಿದ ಸಂಖ್ಯೆ ಯಾವುದು?',
    },
    'tcy': {
      'instruction': '1239 ಸಂಖ್ಯೆ ನೆಂಪು ದೀವೊಲೆ',
      'targetNumber': '1239',
      'recallInstruction': 'ಆರ್ ದುಂಬು ನೋಡಿನ ಸಂಖ್ಯೆ ದಾಯೆ?',
    },
    'en': {
      'instruction': 'Remember this number',
      'targetNumber': '1239',
      'recallInstruction': 'What was the number shown earlier?',
    },
  };

  // ============================================================
  // 4. Word Recall
  // ============================================================
  static const Map<String, Map<String, dynamic>> wordRecall = {
    'kn': {
      'instruction': 'ಈ ಪದಗಳನ್ನು ನೆನಪಿಡಿ',
      'wordsToRemember': [
        'CAR',
        'APPLE',
        'HOUSE',
        'PEN',
        'WATER'
      ],
    },
    'tcy': {
      'instruction': 'ಈ ಪದೊಲೆನ್ ನೆಂಪು ದೀವೊಲೆ',
      'wordsToRemember': [
        'CAR',
        'APPLE',
        'HOUSE',
        'PEN',
        'WATER'
      ],
    },
    'en': {
      'instruction': 'Remember these words',
      'wordsToRemember': [
        'CAR',
        'APPLE',
        'HOUSE',
        'PEN',
        'WATER'
      ],
    },
  };

  // ============================================================
  // 5. Orientation
  // ============================================================
  static const Map<String, Map<String, String>> orientation = {
    'kn': {
      'month': 'ಇದು ಯಾವ ತಿಂಗಳು?',
      'year': 'ಇದು ಯಾವ ವರ್ಷ?',
      'day': 'ಇಂದು ವಾರದ ಯಾವ ದಿನ?',
      'state': 'ನಾವು ಈಗ ಯಾವ ರಾಜ್ಯದಲ್ಲಿದ್ದೇವೆ?',
    },
    'tcy': {
      'month': 'ಉಂದು ವೊವ್ ತಿಂಗೊಲ್?',
      'year': 'ನಮ ವೊವ್ ವರ್ಷೊಡ್ ಉಲ್ಲ?',
      'day': 'ಇನಿ ವಾರೊಡ್ ವೊವ್ ದಿನ?',
      'state': 'ಇತ್ತೆ ನಮ ವಾ ರಾಜ್ಯೊಡು ಉಲ್ಲ',
    },
    'en': {
      'month': 'WHAT MONTH IS THIS?',
      'year': 'WHAT YEAR IS THIS?',
      'day': 'WHAT DAY OF WEEK IS IT, TODAY?',
      'state': 'WHAT STATE ARE WE IN RIGHT NOW?',
    },
  };

  // ============================================================
  // 6. State Options
  // ============================================================
  static const List<String> stateOptions = [
    'ANDRA PRADESH',
    'GOA',
    'KARNATAKA',
    'KERALA',
    'TAMILNADU',
  ];

  // ============================================================
  // 7. Math Problems
  // ============================================================
  static const Map<String, Map<String, dynamic>> mathProblems = {
    'kn': {
      'problem':
          'ನೀವು 100 ರೂಪಾಯಿಗಳೊಂದಿಗೆ ಅಂಗಡಿಗೆ ಹೋಗುತ್ತೀರಿ. ನೀವು 7 ರೂಪಾಯಿಗಳಿಗೆ ಒಂದು ಡಜನ್ ಸೇಬುಗಳನ್ನು ಮತ್ತು 60 ರೂಪಾಯಿಗಳಿಗೆ ಒಂದು ಸೈಕಲ್ ಅನ್ನು ಖರೀದಿಸುತ್ತೀರಿ. ನೀವು ಎಷ್ಟು ಖರ್ಚು ಮಾಡಿದ್ದೀರಿ?',
      'correctAnswer': 67,
      'followUpProblem':
          'ಆ ಖರೀದಿಯ ನಂತರ, ನಿಮ್ಮ ಬಳಿ ಎಷ್ಟು ಹಣ ಉಳಿದಿದೆ?',
      'followUpAnswer': 33,
    },
    'tcy': {
      'problem':
          'ಈರ್ 100 ರೂಪಾಯಿ ಪತೊಂದು ಅಂಗಡಿಗ್ ಪೋಪರ್. ಒಂಜಿ ಡಜನ್ ಸೇಬು ₹7 ಬೊಕ್ಕ ಸೈಕಲ್ ₹60. ಮುಟ್ಟ ಎತ್ತ್ ಕಾಸ್ ಖರ್ಚ್ ಮಲ್ತಿನಿ?',
      'correctAnswer': 67,
      'followUpProblem':
          'ಅವ್ ಪೂರ ದೆತೂಂದು ಬೊಕ್ಕ ಏತ್ ಕಾಸ್ ವೊರಿಂಡ್?',
      'followUpAnswer': 33,
    },
    'en': {
      'problem':
          'YOU GO TO THE STORE WITH EXACTLY Rs100. YOU BUY A DOZEN APPLES FOR Rs7 AND A CYCLE FOR Rs60. HOW MUCH DID YOU SPEND?',
      'correctAnswer': 67,
      'followUpProblem':
          'AFTER THAT PURCHASE, HOW MUCH DO YOU HAVE LEFT?',
      'followUpAnswer': 33,
    },
  };

  // ============================================================
  // 8. Stroop Test
  // ============================================================
  static const Map<String, String> stroop = {
    'kn': 'ಪ್ರತಿ ಪದವನ್ನು ಬರೆಯಲು ಬಳಸುವ ಬಣ್ಣವನ್ನು ಆರಿಸಿ',
    'tcy': 'ಪ್ರತಿಯೊಂಜಿ ಪದೊನ್ ಬರೆಯೆರೆ ಉಪಯೋಗ ಮಲ್ಪುನ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
    'en': 'CHOOSE THE COLOR USED TO WRITE EACH WORD',
  };

  // ============================================================
  // 9. Trail Making Test
  // ============================================================
  static const Map<String, String> trailMaking = {
    'kn':
        'ಚುಕ್ಕೆಗಳನ್ನು ಸೇರಿಸಿ. ಸಂಖ್ಯೆಗಳು ಮತ್ತು ಅಕ್ಷರಗಳ. 1 ರಿಂದ ಪ್ರಾರಂಭಿಸಿ',
    'tcy': 'ಬಿಂದುಲೆನ್ ಸೇರ್ಪಾಲೆ',
    'en':
        'CONNECT THE DOTS ALTERNATING NUMBERS AND LETTERS. START AT 1, CONNECT TO A, THEN TO 2, THEN TO B, AND SO ON.',
  };

  // ============================================================
  // 10. Visuospatial Assembly
  // ============================================================
  static const Map<String, String> drawingAssembly = {
    'kn': 'ದೊಡ್ಡ ರೇಖಾಚಿತ್ರವನ್ನು ಮಾಡುವ ಸಣ್ಣ ರೇಖಾಚಿತ್ರಗಳನ್ನು ಆರಿಸಿ',
    'tcy':
        'ಮಲ್ಲ ಡ್ರಾಯಿಂಗ್ ನ್ ಪಲ್ಪರೆಗ್, ಎಲ್ಯ ಡ್ರಾಯಿಂಗ್ ಲೆನ್ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
    'en':
        'PICK THE SMALL DRAWINGS THAT MAKE UP THE BIG DRAWING',
  };
}
