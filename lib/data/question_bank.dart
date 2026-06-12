/// Nenavi Question Bank
/// Languages: 'kn' (Kannada), 'tcy' (Tulu), 'en' (English)

class QuestionBank {
  // ============================================================
  // 1. Letter task (Pick the fruit words)
  // ============================================================
  static const Map<String, Map<String, dynamic>> letterTask = {
    'kn': {
      'instruction': 'ಹಣ್ಣಿನ ಪದಗಳನ್ನು ಆರಿಸಿ',
      'options': ['ಬಾಳೆಹಣ್ಣು', 'ಚರ್ಚ್', 'ಕಿತ್ತಳೆ', 'ಸ್ಟೇಪ್ಲರ್'],
      'correct': ['ಬಾಳೆಹಣ್ಣು', 'ಕಿತ್ತಳೆ'],
    },
    'tcy': {
      'instruction': 'ಫಲ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
      'options': ['ಪರ್ನ್ದು', 'ಚರ್ಚ್', 'ಕಿತ್ತಲೆ', 'ಸ್ಟೇಪ್ಲರ್'],
      'correct': ['ಪರ್ನ್ದು', 'ಕಿತ್ತಲೆ'],
    },
    'en': {
      'instruction': 'Pick the fruit words',
      'options': ['banana', 'church', 'orange', 'stapler'],
      'correct': ['banana', 'orange'],
    },
  };

  // ============================================================
  // 2. Remember words (Encoding) and Delayed recall
  // ============================================================
  static const Map<String, Map<String, dynamic>> wordRecall = {
    'kn': {
      'instruction': 'ಪದಗಳನ್ನು ನೆನಪಿಡಿ',
      'wordsToRemember': ['ಕಾರು', 'ಸೇಬು', 'ಮನೆ', 'ಪೆನ್', 'ನೀರು'],
      'recallInstruction': 'ನೀವು ಆರಂಭದಲ್ಲಿ ಓದಿದ ವಾಕ್ಯವನ್ನು ಆರಿಸಿ',
      'phraseOptions': [
        'ನೀರು ಕುಡಿಯಿರಿ',
        'ಹಾಡು ಹಾಡಿ',
        'ಕಣ್ಣು ಮುಚ್ಚಿಕೊಳ್ಳಿ',
        'ನಾನು ಒಳ್ಳೆಯ ವ್ಯಕ್ತಿ',
        'ಚಪ್ಪಾಳೆ ತಟ್ಟಿ'
      ],
      'correctPhrase': 'ನಾನು ಒಳ್ಳೆಯ ವ್ಯಕ್ತಿ',
    },
    'tcy': {
      'instruction': 'ಪದೊಕುಲೆನ್ ನೆಂಪು ಮಲ್ಪುಲೆ',
      'wordsToRemember': ['ಕಾರ್', 'ಸೇಬು', 'ಇಲ್ಲ್', 'ಪೆನ್', 'ನೀರ್'],
      'recallInstruction': 'ಈರ್ ದುಂಬು ಪಂತಿನ ವಾಕ್ಯೊನು ಇತ್ತೆ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ.',
      'phraseOptions': [
        'ನೀರ್ ಪರ್ಲೆ',
        'ಒಂಜಿ ಪದ್ಯನ್ ಪನ್ಲೆ',
        'ಕಣ್ಣ್ ಮುಚ್ಚುಲೆ',
        'ಯಾನ್ ಒರಿ ಎಡ್ಡೆ ವ್ಯಕ್ತಿ',
        'ಕೈನ್ ತಟ್ಟಲೆ'
      ],
      'correctPhrase': 'ಯಾನ್ ಒರಿ ಎಡ್ಡೆ ವ್ಯಕ್ತಿ',
    },
    'en': {
      'instruction': 'Remember the words',
      'wordsToRemember': ['CAR', 'APPLE', 'HOUSE', 'PEN', 'WATER'],
      'recallInstruction': 'SELECT THE PHRASE YOU READ EARLIER IN THE BEGINNING',
      'phraseOptions': [
        'DRINK WATER',
        'SING A SONG',
        'CLOSE YOUR EYES',
        'I AM A GOOD PERSON',
        'CLAP YOUR HANDS'
      ],
      'correctPhrase': 'I AM A GOOD PERSON',
    },
  };

  // ============================================================
  // 3. Remember the number and type it after sometime
  // ============================================================
  static const Map<String, Map<String, dynamic>> numberMemory = {
    'kn': {
      'instruction': '1239 ಸಂಖ್ಯೆಯನ್ನು ಒತ್ತಿರಿ',
      'targetNumber': '1239',
    },
    'tcy': {
      'instruction': '1239 ಸಂಖ್ಯೆ ಒತ್ತುಲೆ',
      'targetNumber': '1239',
    },
    'en': {
      'instruction': 'PRESS THE NUMBER 1239',
      'targetNumber': '1239',
    },
  };

  // ============================================================
  // 4,5,6. Orientation (Month, Year, Day, State)
  // ============================================================
  static const Map<String, Map<String, dynamic>> orientation = {
    'kn': {
      'monthQuestion': 'ಇದು ಯಾವ ತಿಂಗಳು?',
      'yearQuestion': 'ಇದು ಯಾವ ವರ್ಷ?',
      'dayQuestion': 'ಇಂದು ವಾರದ ಯಾವ ದಿನ?',
      'stateQuestion': 'ನಾವು ಈಗ ಯಾವ ರಾಜ್ಯದಲ್ಲಿದ್ದೇವೆ?',
      'months': [
        'ಜನವರಿ', 'ಫೆಬ್ರವರಿ', 'ಮಾರ್ಚ್', 'ಏಪ್ರಿಲ್', 'ಮೇ', 'ಜೂನ್',
        'ಜುಲೈ', 'ಆಗಸ್ಟ್', 'ಸೆಪ್ಟೆಂಬರ್', 'ಅಕ್ಟೋಬರ್', 'ನವೆಂಬರ್', 'ಡಿಸೆಂಬರ್'
      ],
      'days': [
        'ಭಾನುವಾರ', 'ಸೋಮವಾರ', 'ಮಂಗಳವಾರ', 'ಬುಧವಾರ', 'ಗುರುವಾರ', 'शुक्रವಾರ', 'ಶನಿವಾರ'
      ],
      'states': ['ಆಂಧ್ರಪ್ರದೇಶ', 'ಗೋವಾ', 'ಕರ್ನಾಟಕ', 'ಕೇರಳ', 'ತಮಿಳುನಾಡು'],
    },
    'tcy': {
      'monthQuestion': 'ಉಂದು ವೊವ್ ತಿಂಗೊಲ್?',
      'yearQuestion': 'ನಮ ವೊವ್ ವರ್ಷೊಡ್ ಉಲ್ಲ??',
      'dayQuestion': 'ಇನಿ ವಾರೊಡ್ ವೊವ್ ದಿನ?',
      'stateQuestion': 'ಇತ್ತೆ nಮ ವಾ ರಾಜ್ಯೊಡು ಉಲ್ಲ',
      'months': [
        'ಜನವರಿ', 'ಫೆಬ್ರವರಿ', 'ಮಾರ್ಚ್', 'ಏಪ್ರಿಲ್', 'ಮೇ', 'ಜೂನ್',
        'ಜುಲೈ', 'ಆಗಸ್ಟ್', 'ಸೆಪ್ಟೆಂಬರ್', 'ಅಕ್ಟೋಬರ್', 'ನವೆಂಬರ್', 'ಡಿಸೆಂಬರ್'
      ],
      'days': [
        'ಅಯಿತಾರ', 'ಸೋಮಾರ', 'ಅಂಗಾರ', 'ಬುದಾರ', 'ಗುರುವಾರ', 'ಶುಕ್ರಾರ', 'ಶನಿವಾರ'
      ],
      'states': ['ಆಂಧ್ರಪ್ರದೇಶ', 'ಗೋವಾ', 'ಕರ್ನಾಟಕ', 'ಕೇರಳ', 'ತಮಿಳುನಾಡು'],
    },
    'en': {
      'monthQuestion': 'WHAT MONTH IS THIS?',
      'yearQuestion': 'WHAT YEAR IS THIS?',
      'dayQuestion': 'WHAT DAY OF WEEK IS IT, TODAY?',
      'stateQuestion': 'WHAT STATE ARE WE IN RIGHT NOW?',
      'months': [
        'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
        'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
      ],
      'days': [
        'SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'
      ],
      'states': ['ANDRA PRADESH', 'GOA', 'KARNATAKA', 'KERALA', 'TAMILNADU'],
    },
  };

  // ============================================================
  // 7. Simple math calculations
  // ============================================================
  static const Map<String, Map<String, dynamic>> mathProblems = {
    'kn': {
      'problem': 'ನೀವು 100 ರೂಪಾಯಿಗಳೊಂದಿಗೆ ಅಂಗಡಿಗೆ ಹೋಗುತ್ತೀರಿ. ನೀವು 7 ರೂಪಾಯಿಗಳಿಗೆ ಒಂದು ಡಜನ್ ಸೇಬುಗಳನ್ನು ಮತ್ತು 60 ರೂಪಾಯಿಗಳಿಗೆ ಒಂದು ಸೈಕಲ್ ಅನ್ನು ಖರೀದಿಸುತ್ತೀರಿ. ನೀವು ಎಷ್ಟು ಖರ್ಚು ಮಾಡಿದ್ದೀರಿ?',
      'correctAnswer': 67,
      'followUpProblem': 'ಆ ಖರೀದಿಯ ನಂತರ, ನಿಮ್ಮ ಬಳಿ ಎಷ್ಟು ಹಣ ಉಳಿದಿದೆ?',
      'followUpAnswer': 33,
    },
    'tcy': {
      'problem': 'ಈರ್ 100 ರೂಪಾಯಿ ಪತೊಂದು ಅಂಗಡಿಗ್ ಪೋಪರ್. ಈರ್ ಒಂಜಿ ಡಜನ್ ಸೇಬು ನ್ 7 ರೂಪಾಯಿಗ್ ಬೊಕ್ಕ ಒಂಜಿ ಸೈಕಲ್ ನ್ 60 ರೂಪಾಯಿಗ್ ದೆತೊನುವರ್. ಈರ್ ಏತ್ ಖರ್ಚು ಮಲ್ತರ್?',
      'correctAnswer': 67,
      'followUpProblem': 'ಅವ್ ಪೂರ ದೆತೂಂದು ಬೊಕ್ಕ ಏತ್ ಕಾಸ್ ವೊರಿಂಡ್?',
      'followUpAnswer': 33,
    },
    'en': {
      'problem': 'YOU GO TO THE STORE WITH EXACTLY Rs100. YOU BUY A DOZEN APPLES FOR Rs7 AND A CYCLE FOR Rs60. HOW MUCH DID YOU SPEND?',
      'correctAnswer': 67,
      'followUpProblem': 'AFTER THAT PURCHASE, HOW MUCH DO YOU HAVE LEFT?',
      'followUpAnswer': 33,
    },
  };

  // ============================================================
  // 8. Visual & Game Instructions (Drawing, Color, Connect the dots)
  // ============================================================
  static const Map<String, Map<String, dynamic>> gameInstructions = {
    'kn': {
      'drawingTask': 'ಮುಂದೆ, ನೀವು ಕೆಲವು ರೇಖಾಚಿತ್ರಗಳನ್ನು ನೋಡುತ್ತೀರಿ. ದೊಡ್ಡ ರೇಖಾಚಿತ್ರವನ್ನು ಮಾಡುವ ಸಣ್ಣ ರೇಖಾಚಿತ್ರಗಳನ್ನು ಆರಿಸಿ.',
      'colorTask': 'ಮುಂದೆ, ನೀವು ಕೆಲವು ಪದಗಳನ್ನು ನೋಡುತ್ತೀರಿ. ಪ್ರತಿ ಪದವನ್ನು ಬರೆಯಲು ಬಳಸುವ ಬಣ್ಣವನ್ನು ಆರಿಸಿ.',
      'almostDone': 'ನೀವು ಬಹುತೇಕ ಮುಗಿಸಿದ್ದೀರಿ! ಅಂತಿಮ ಕಾರ್ಯಗಳಿಗಾಗಿ, ನೀವು ಚುಕ್ಕೆಗಳನ್ನು ಜೋಡಿಸಿ ಆಟವಾಡಿ.',
      'connectDots1': 'ಒಂದು ಚುಕ್ಕೆಯಿಂದ ಮುಂದಿನದಕ್ಕೆ ರೇಖೆಗಳನ್ನು ಎಳೆಯಿರಿ. ಸಂಖ್ಯೆಯ ಚುಕ್ಕೆಗಳು ಏರಿಕೆಯ ಕ್ರಮದಲ್ಲಿ ಹೋಗುತ್ತವೆ (1, 2, 3, ... ) ಅಕ್ಷರಗಳನ್ನು ಹೊಂದಿರುವ ಚುಕ್ಕೆಗಳು ವರ್ಣಮಾಲೆಯ ಕ್ರಮದಲ್ಲಿ ಹೋಗುತ್ತವೆ (A, B, C, ... )',
      'connectDots2': 'ಚುಕ್ಕೆಗಳನ್ನು ಸೇರಿಸಿ. ಸಂಖ್ಯೆಗಳು ಮತ್ತು ಅಕ್ಷರಗಳ. 1 ರಿಂದ ಪ್ರಾರಂಭಿಸಿ, ಅದನ್ನು ಮೊದಲ ಅಕ್ಷರಕ್ಕೆ, A ಗೆ ಸೇರಿಸಿ.ನಂತರ, A ನಿಂದ 2 ಗೆ ಮತ್ತು 2 ಅನ್ನು ಮುಂದಿನ ಅಕ್ಷರಕ್ಕೆ. ನೀವು ಅಂತ್ಯವನ್ನು ತಲುಪುವವರೆಗೆ ಮುಂದುವರಿಸಿ.',
      'thankYou': 'ನೀವು ಪರೀಕ್ಷೆಗಳನ್ನು ಮುಗಿಸಿದ್ದೀರಿ! ನಿಮ್ಮ ಸಮಯಕ್ಕೆ ಧನ್ಯವಾದಗಳು.',
    },
    'tcy': {
      'drawingTask': 'ದುಂಬು, ಈರ್ ಕೆಲವ್ ಚಿತ್ರೊಲೆನ್ ತೂಪರ್. ಮಲ್ಲ ಡ್ರಾಯಿಂಗ್ ನ್ ಪಲ್ಪರೆಗ್, ಎಲ್ಯ ಡ್ರಾಯಿಂಗ್ ಲೆನ್ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ.',
      'colorTask': 'ದುಂಬು, ಈರ್ ಕೆಲವ್ ಪದಲೆನ್ ತೂಪರ್. ಪ್ರತಿಯೊಂಜಿ ಪದೊನ್ ಬರೆಯೆರೆ ಉಪಯೋಗ ಮಲ್ಪುನ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ.',
      'almostDone': 'ನಿಗಲ್ನ ಮೌಲ್ಯಮಪನ ಮುಗಿತೊಂದು ಬೈದುಂಡು. ಕಡೆತ ಕಾರ್ಯಗ್, ಈರ್ ಬಿಂದುಲೆನ್ ಸೇರ್ಪಾಲೆ ಆಟವಾಡಿ.',
      'connectDots1': 'ಒಂಜಿ ಬಿಂದುಡ್ದ್ ಬೊಕ್ಕೊಂಜಿ ಬಿಂದುಗು ರೇಖೆಲೆನ್ ಬರೆಲೆ.ಸಂಖ್ಯೆದ ಬಿಂದುಲು ಕಡಿಮೆಡ್ದ್ ಎಚ್ಚೊಗು ಪೋಪುಂಡು (1, 2, 3, ... ).ಅಕ್ಷರೊಲೆನ ಬಿಂದುಲು ಅಕ್ಷರಮಾಲೆದ ಕ್ರಮೊಟು ಪೋಪುಂಡು (ಎ, ಬಿ, ಸಿ, ... ).',
      'connectDots2': 'ಬಿಂದುಲೆನ್ ಸೇರ್ಪಾಲೆ. ಸಂಖ್ಯೆಲು ಬೊಕ್ಕ ಅಕ್ಷರೊಲೆನ್ ಪರ್ಯಾಯವಾದ್ ಸೇರ್ಪಾಲೆ. 1ಡ್ದ್ ಸುರು ಮಲ್ಪುಲೆ, ಸುರುತ ಅಕ್ಷರೊಗು ಸೇರ್ಪಾಲೆ , A. ಬೊಕ್ಕ, A ನ್ 2 ಗ್, ಬೊಕ್ಕ 2 ನ್ ದುಂಬುದ ಅಕ್ಷರೊಗು ಸೇರ್ಪಾಲೆ. ಈರ್ ಅಂತ್ಯೊಗು ಬರ್ಪಿನ ಮುಟ್ಟ ನಡತೊಂದು ಪೋಲೆ.',
      'thankYou': 'ಈರ್ ಪರೀಕ್ಷೆನ್ ಮುಗಿತರ್.ಸೊಲ್ಮೆಲು.',
    },
    'en': {
      'drawingTask': 'NEXT, YOU WILL SEE SOME DRAWINGS. PICK THE SMALL DRAWINGS THAT MAKE UP THE BIG DRAWING.',
      'colorTask': 'NEXT, YOU WILL SEE SOME WORDS. CHOOSE THE COLOR USED TO WRITE EACH WORD.',
      'almostDone': 'YOU ARE ALMOST DONE! FOR THE FINAL TASKS, YOU PLAY CONNECT-THE-DOTS.',
      'connectDots1': 'DRAW LINES FROM ONE DOT TO THE NEXT. NUMBERED DOTS GO FROM LOW TO HIGH (1, 2, 3, 4 ... ) DOTS WITH LETTERS GO IN ALPHABETICAL ORDER (A, B, C, D ... )',
      'connectDots2': 'CONNECT THE DOTS ALTERNATE NUMBERS AND LETTERS. START AT 1, CONNECT IT TO THE FIRST LETTER, A. THEN, CONNECT A TO 2, AND 2 TO THE NEXT LETTER. KEEP GOING UNTIL YOU REACH THE END.',
      'thankYou': "YOU'RE DONE WITH THE TESTS! THANK YOU FOR YOUR TIME.",
    },
  };
}
