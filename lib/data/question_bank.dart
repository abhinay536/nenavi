/// Nenavi Question Bank
/// Languages: 'kn' (Kannada), 'tcy' (Tulu), 'en' (English)
/// Tulu entries are placeholders marked with TODO.

class QuestionBank {
  // ============================================================
  // 1. Letter task (Pick the word that starts with a given letter)
  // ============================================================
  static const Map<String, Map<String, dynamic>> letterTask = {
    'kn': {
      'instruction': 'ಈ ಅಕ್ಷರದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ಪದವನ್ನು ಆಯ್ಕೆಮಾಡಿ:',
      'letter': 'ಜ',
      'options': ['ಜನವರಿ', 'ಮನೆ', 'ನೀರು'],
      'correct': 'ಜನವರಿ',
    },
    'tcy': {
      'instruction': 'ಈ ಅಕ್ಷರೊಡ್ದು ಸುರು ಆಪುನ ಪದೊನು ಆಯ್ಕೆ ಮಲ್ಪುಲೆ:',
      'letter': 'ಜ',
      'options': ['ಜನವರಿ', 'ಮನೆ', 'ನೀರು'], // TODO: use Tulu words
      'correct': 'ಜನವರಿ',
    },
    'en': {
      'instruction': 'Select the word that starts with the letter:',
      'letter': 'J',
      'options': ['January', 'House', 'Water'],
      'correct': 'January',
    },
  };

  // ============================================================
  // 2. Remember words (Encoding) and Delayed recall
  // ============================================================
  static const Map<String, Map<String, dynamic>> wordRecall = {
    'kn': {
      'instruction': 'ಈ ಐದು ಪದಗಳನ್ನು ನೆನಪಿಟ್ಟುಕೊಳ್ಳಿ. ನಂತರ ಕೇಳಲಾಗುವುದು.',
      'wordsToRemember': ['ಮರ', 'ಹೂವು', 'ಬಸ್ಸು', 'ಕಾಗದ', 'ಬೆಕ್ಕು'],
      'distractors': ['ಕಲ್ಲು', 'ಮಳೆ', 'ಕುರ್ಚಿ', 'ಹಕ್ಕಿ', 'ಮೀನು'],
    },
    'tcy': {
      'instruction': 'ಈ ಐನ್ ಪದೊಲೆನ್ ನೆಂಪು ದೀವೊಲೆ. ಬೊಕ್ಕ ಕೇನುವೆರ್.',
      'wordsToRemember': ['ಮರ', 'ಹೂವು', 'ಬಸ್ಸು', 'ಕಾಗದ', 'ಬೆಕ್ಕು'], // TODO
      'distractors': ['ಕಲ್ಲು', 'ಮಳೆ', 'ಕುರ್ಚಿ', 'ಹಕ್ಕಿ', 'ಮೀನು'],
    },
    'en': {
      'instruction':
          'Remember these five words. You will be asked to recall them later.',
      'wordsToRemember': ['tree', 'flower', 'bus', 'paper', 'cat'],
      'distractors': ['stone', 'rain', 'chair', 'bird', 'fish'],
    },
  };

  // ============================================================
  // 3. Remember the number and type it after sometime
  // ============================================================
  static const Map<String, Map<String, dynamic>> numberMemory = {
    'kn': {
      'instruction': 'ಈ ಸಂಖ್ಯೆಯನ್ನು ನೆನಪಿಡಿ:',
      'targetNumber': '1239',
      'recallInstruction': 'ನೀವು ಮೊದಲು ನಮೂದಿಸಿದ ಸಂಖ್ಯೆ ಯಾವುದು?',
    },
    'tcy': {
      'instruction': 'ಈ ಸಂಖ್ಯೆನ್ ನೆಂಪು ದೀವೊಲೆ:',
      'targetNumber': '1239',
      'recallInstruction': 'ಆರ್ ದುಂಬು ನಮೂದಿಸಿನ ಸಂಖ್ಯೆ ದಾಯೆ?',
    },
    'en': {
      'instruction': 'Remember this number:',
      'targetNumber': '1239',
      'recallInstruction': 'What was the number you entered earlier?',
    },
  };

  // ============================================================
  // 4,5,6. Orientation (Month, Year, Day)
  // ============================================================
  static const Map<String, Map<String, String>> orientation = {
    'kn': {
      'month': 'ಈ ತಿಂಗಳು ಯಾವುದು?',
      'year': 'ಈ ವರ್ಷ ಯಾವುದು?',
      'day': 'ಇಂದು ವಾರದ ಯಾವ ದಿನ?',
    },
    'tcy': {
      'month': 'ಈ ತಿಂಗೊಲು ದಾಯೆ?',
      'year': 'ಈ ವರ್ಸೊ ದಾಯೆ?',
      'day': 'ಇನಿ ವಾರೊದ ದಿನ ದಾಯೆ?',
    },
    'en': {
      'month': 'What month is this?',
      'year': 'What year is this?',
      'day': 'What day of the week is today?',
    },
  };

  // ============================================================
  // 7. Simple math calculations
  // ============================================================
  static const Map<String, Map<String, dynamic>> mathProblems = {
    'kn': {
      'problem':
          'ಒಂದು ಡಜನ್ ಸೇಬುಗಳ ಬೆಲೆ ₹7 ಮತ್ತು ಒಂದು ಟ್ರೈಸಿಕಲ್ ಬೆಲೆ ₹60 ಆದರೆ, ಒಟ್ಟು ಎಷ್ಟು?',
      'correctAnswer': 67,
      'followUpProblem': '₹100 ಕೊಟ್ಟರೆ ಎಷ್ಟು ಹಣ ಉಳಿಯುತ್ತದೆ?',
      'followUpAnswer': 33,
    },
    'tcy': {
      'problem':
          'ಒಂಜಿ ಡಜನ್ ಸೇಬುದ ಬೆಲೆ ₹7 ಬೊಕ್ಕ ಒಂಜಿ ಟ್ರೈಸಿಕಲ್ದ ಬೆಲೆ ₹60 ಆಂಡ, ಮುಟ್ಟ ಎತ್ತ್?',
      'correctAnswer': 67,
      'followUpProblem': '₹100 ಕೊರಿಂಡ ಎತ್ತ್ ಕಾಸ್ ಉಂತುಂಡು?',
      'followUpAnswer': 33,
    },
    'en': {
      'problem':
          'One dozen apples cost ₹7 and a tricycle costs ₹60. What is the total?',
      'correctAnswer': 67,
      'followUpProblem': 'If you pay ₹100, how much change will you get?',
      'followUpAnswer': 33,
    },
  };
}
