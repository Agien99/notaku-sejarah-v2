import 'package:flutter/material.dart';

import '../../quiz/data/quiz_repository.dart';
import '../../quiz/presentation/quiz_attempt_screen.dart';
import '../domain/quiz_record.dart';

String recordDate(DateTime value) {
  final date = value.toLocal();
  String pad(int value) => value.toString().padLeft(2, '0');
  return '${pad(date.day)}/${pad(date.month)}/${date.year} '
      '${pad(date.hour)}:${pad(date.minute)}';
}

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({required this.record, super.key});
  final QuizRecord record;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Butiran Percubaan')),
    body: SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 840),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Tingkatan ${record.form} • Bab ${record.chapter}',
            style: Theme.of(context).textTheme.titleMedium),
          Text(record.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text('${record.percentage.toStringAsFixed(0)}% • '
            '${record.score}/${record.total} betul',
            style: Theme.of(context).textTheme.headlineMedium),
          Text('Selesai: ${recordDate(record.completedAt)}'),
          Text('Tempoh: ${record.duration.inMinutes} min '
            '${record.duration.inSeconds % 60} saat'),
          const SizedBox(height: 16),
          Align(alignment: Alignment.centerLeft, child: OutlinedButton.icon(
            icon: const Icon(Icons.replay),
            label: const Text('Cuba kuiz bab ini'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => QuizAttemptScreen(
                form: record.form, chapter: record.chapter, title: record.title,
                repository: QuizRepository(),
              ),
            )),
          )),
          const SizedBox(height: 16),
          const Text('Semakan Jawapan'),
          for (var index = 0; index < record.answers.length; index++)
            Card(child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. ${record.answers[index].prompt}',
                    style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Text(record.answers[index].isCorrect ? '✓ Betul' : '✗ Salah'),
                  Text('Jawapan anda: ${record.answers[index].selectedAnswer}'),
                  Text('Jawapan betul: ${record.answers[index].correctAnswer}'),
                  const SizedBox(height: 8),
                  Text(record.answers[index].explanation),
                ],
              ),
            )),
        ],
      ),
    ))),
  );
}

class RecordTile extends StatelessWidget {
  const RecordTile({required this.record, super.key});
  final QuizRecord record;

  @override
  Widget build(BuildContext context) => Card(child: ListTile(
    title: Text('T${record.form} • Bab ${record.chapter}: ${record.title}'),
    subtitle: Text('${recordDate(record.completedAt)}\n'
      '${record.score}/${record.total} betul • '
      '${record.percentage.toStringAsFixed(0)}%'),
    isThreeLine: true,
    trailing: const Icon(Icons.chevron_right),
    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => RecordDetailScreen(record: record),
    )),
  ));
}
