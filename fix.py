import os

def parse_balanced(s, start_idx):
    # returns (inner_content, end_idx)
    depth = 1
    idx = start_idx
    while idx < len(s):
        if s[idx] == '(':
            depth += 1
        elif s[idx] == ')':
            depth -= 1
            if depth == 0:
                return s[start_idx:idx], idx
        idx += 1
    return "", -1

def replace_speakables(path):
    with open(path, 'r', encoding='utf-8') as f:
        s = f.read()

    # Process SpeakableText
    while True:
        idx = s.find('SpeakableText(')
        if idx == -1:
            break
        inner, end_idx = parse_balanced(s, idx + len('SpeakableText('))
        
        # We have the inner content.
        # Find 'text: ' and 'language: '
        import re
        inner = re.sub(r'text:\s*', '', inner, count=1)
        inner = re.sub(r'language:\s*[a-zA-Z0-9_\.]+,?\s*', '', inner, count=1)
        
        s = s[:idx] + 'Text(' + inner + ')' + s[end_idx+1:]

    # Process SpeakableOptionButton
    while True:
        idx = s.find('SpeakableOptionButton(')
        if idx == -1:
            break
        inner, end_idx = parse_balanced(s, idx + len('SpeakableOptionButton('))
        
        import re
        # extract text value
        m = re.search(r'text:\s*(.*?)(?=$|,\s*language:|,\s*style:|,\s*onPressed:)', inner, re.DOTALL)
        text_val = m.group(1) if m else "''"
        
        inner = re.sub(r'text:\s*.*?(?=$|,\s*language:|,\s*style:|,\s*onPressed:)', f'child: Text({text_val})', inner, count=1, flags=re.DOTALL)
        inner = re.sub(r'language:\s*[a-zA-Z0-9_\.]+,?\s*', '', inner, count=1)
        
        s = s[:idx] + 'ElevatedButton(' + inner + ')' + s[end_idx+1:]

    with open(path, 'w', encoding='utf-8') as f:
        f.write(s)

files = [
    'lib/screens/login_screen.dart',
    'lib/screens/register_screen.dart',
    'lib/home_screen.dart',
    'lib/screens/caregiver_home_screen.dart',
    'lib/screens/caregiver_patients_screen.dart'
]

for f in files:
    if os.path.exists(f):
        replace_speakables(f)
