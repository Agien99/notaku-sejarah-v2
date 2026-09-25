import 'package:flutter/material.dart';

import '../../notes/data/note_repository.dart';
import '../../notes/domain/models/note_form.dart';
import '../data/quiz_manifest.dart';
import '../data/quiz_repository.dart';
import 'quiz_attempt_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forms = const LocalNoteRepository().getForms();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('KUIZ', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(
          'Uji kefahaman anda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Pilih tingkatan dan bab. Jawab 15 soalan rawak, kemudian semak '
          'jawapan dan penerangan anda.',
        ),
        const SizedBox(height: 24),
        for (final form in forms) ...[
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.quiz_outlined),
              title: Text(form.title),
              subtitle: Text(form.theme),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => QuizChapterScreen(form: form),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class QuizChapterScreen extends StatelessWidget {
  const QuizChapterScreen({required this.form, super.key});

  final NoteForm form;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuiz ${form.title}')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('Pilih bab', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text('15 soalan setiap sesi • Soalan dan jawapan dirawak'),
                const SizedBox(height: 24),
                for (final chapter in form.chapters) ...[
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text('${chapter.label}: ${chapter.title}'),
                      subtitle: Text(
                        quizAssetManifest.containsKey(
                          quizChapterKey(form.level, chapter.number),
                        )
                            ? 'Mulakan kuiz'
                            : 'Belum tersedia',
                      ),
                      trailing: Icon(
                        quizAssetManifest.containsKey(
                          quizChapterKey(form.level, chapter.number),
                        )
                            ? Icons.play_circle_outline
                            : Icons.lock_outline,
                      ),
                      onTap: quizAssetManifest.containsKey(
                        quizChapterKey(form.level, chapter.number),
                      )
                          ? () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => QuizAttemptScreen(
                                  form: form.level,
                                  chapter: chapter.number,
                                  title: chapter.title,
                                  repository: QuizRepository(),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
