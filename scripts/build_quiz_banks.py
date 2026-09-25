"""Compile explicitly authored, four-way matching items into runtime assets.

Each block has a category and four mutually exclusive answers, followed by four
independently authored descriptions. Each description maps to one answer. No
reverse questions, random distractor mining, or filler questions are generated.
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def compile_banks():
    manifest = []
    check = '--check' in sys.argv

    def output(path, text):
        target = ROOT / path
        if check:
            if not target.exists() or target.read_text() != text:
                raise ValueError(f'Generated file is stale: {path}')
        else:
            target.write_text(text)
    for source in sorted((ROOT / 'content/quiz').glob('t*.txt')):
        form = int(source.stem[1:])
        chapter = None
        questions = []
        category = None
        answers = []
        position = 0

        def save():
            if chapter is None:
                return
            path = f'assets/quiz/kssm_2026/t{form}_b{chapter:02}.json'
            note = json.loads((ROOT / path.replace('/quiz/', '/notes/')).read_text())
            assert len(questions) == 40, (form, chapter, len(questions))
            assert len({q['prompt'] for q in questions}) == 40
            data = dict(curriculum='KSSM', contentVersion='2026.2', form=form,
                        chapter=chapter, title=note['title'],
                        editorialStatus='original-practice',
                        sourceNote=path.replace('/quiz/', '/notes/'),
                        questions=questions)
            output(path, json.dumps(data, ensure_ascii=False, indent=2) + '\n')
            manifest.append((form, chapter, path))

        for line in source.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith('//'):
                continue
            if line.startswith('#'):
                if category is not None:
                    assert position == 4
                save()
                chapter = int(line[1:])
                questions = []
                category = None
            elif line.startswith('@'):
                if category is not None:
                    assert position == 4, (form, chapter, category)
                category, *answers = line[1:].split('|')
                assert len(answers) == 4 and len(set(answers)) == 4
                position = 0
            else:
                assert position < 4 and category and chapter
                number = len(questions) + 1
                # Balance stored keys; runtime additionally shuffles all choices.
                offset = ((number - 1) // 4) % 4
                ordered = answers[offset:] + answers[:offset]
                correct = answers[position]
                questions.append(dict(
                    id=f't{form}-b{chapter:02}-q{number:03}', form=form, chapter=chapter,
                    prompt=f'{category}\n\n{line}',
                    options=[dict(id=chr(65+i), text=text) for i, text in enumerate(ordered)],
                    correctOptionId=chr(65+ordered.index(correct)),
                    explanation=f'{correct}: {line}', tags=['padanan', f'bab-{chapter}'],
                ))
                position += 1
        assert position == 4
        save()
    expected = {(form, chapter) for form, count in [(1, 8), (2, 10), (3, 8), (4, 10), (5, 10)]
                for chapter in range(1, count + 1)}
    assert {(form, chapter) for form, chapter, _ in manifest} == expected
    text = 'const quizAssetManifest = <String, String>{\n'
    text += ''.join(f"  '{form}:{chapter}': '{path}',\n" for form, chapter, path in manifest)
    text += "};\n\nString quizChapterKey(int form, int chapter) => '$form:$chapter';\n"
    output('lib/features/quiz/data/quiz_manifest.dart', text)
    print(f'{len(manifest)} chapters; {len(manifest) * 40} questions')


if __name__ == '__main__':
    compile_banks()
