import 'package:flutter/material.dart';

import '../data/records_repository.dart';
import '../domain/quiz_record.dart';
import 'record_detail_screen.dart';
import 'records_builder.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({this.repository, super.key});
  final RecordsRepository? repository;

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  int? _form;
  int? _chapter;
  int _limit = 20;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Rekod & Statistik',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      const Text('Jejaki kemajuan dan semak semula jawapan kuiz anda.'),
      const SizedBox(height: 20),
      RecordsBuilder(
        repository: widget.repository,
        builder: (context, repository) {
          final records = repository.records;
          if (records.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48),
                    SizedBox(height: 12),
                    Text('Belum ada rekod kuiz'),
                    Text(
                      'Selesaikan kuiz di tab Kuiz. Keputusan anda akan disimpan di sini.',
                    ),
                  ],
                ),
              ),
            );
          }
          final filtered = records
              .where(
                (record) =>
                    (_form == null || record.form == _form) &&
                    (_chapter == null || record.chapter == _chapter),
              )
              .toList();
          final statistics = RecordStatistics(filtered);
          final chapters =
              records
                  .where((r) => r.form == _form)
                  .map((r) => r.chapter)
                  .toSet()
                  .toList()
                ..sort();
          final groups = <String, List<QuizRecord>>{};
          for (final record in filtered) {
            final label = _form == null
                ? 'Tingkatan ${record.form}'
                : 'Bab ${record.chapter}: ${record.title}';
            groups.putIfAbsent(label, () => []).add(record);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final form in <int?>[null, 1, 2, 3, 4, 5])
                    ChoiceChip(
                      label: Text(form == null ? 'Semua' : 'Tingkatan $form'),
                      selected: _form == form,
                      onSelected: (_) => setState(() {
                        _form = form;
                        _chapter = null;
                        _limit = 20;
                      }),
                    ),
                ],
              ),
              if (_form != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final chapter in <int?>[null, ...chapters])
                      ChoiceChip(
                        label: Text(
                          chapter == null ? 'Semua bab' : 'Bab $chapter',
                        ),
                        selected: _chapter == chapter,
                        onSelected: (_) => setState(() {
                          _chapter = chapter;
                          _limit = 20;
                        }),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              if (filtered.isEmpty)
                const Text('Tiada percubaan untuk pilihan ini.')
              else ...[
                StatisticsSummary(statistics: statistics),
                const SizedBox(height: 20),
                Text(
                  'Prestasi mengikut ${_form == null ? 'Tingkatan' : 'Bab'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final label in groups.keys.toList()..sort())
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(label),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value:
                                RecordStatistics(groups[label]!).average / 100,
                            semanticsLabel: 'Purata $label',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${groups[label]!.length} percubaan • Purata '
                            '${RecordStatistics(groups[label]!).average.toStringAsFixed(1)}% • Terbaik '
                            '${RecordStatistics(groups[label]!).best.toStringAsFixed(1)}%',
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Sejarah Percubaan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text(
                  'Terbaharu dahulu • Ketik rekod untuk semakan jawapan.',
                ),
                for (final record in filtered.take(_limit))
                  RecordTile(record: record),
                if (filtered.length > _limit)
                  TextButton(
                    onPressed: () => setState(() => _limit += 20),
                    child: const Text('Lihat lebih banyak'),
                  ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Rekod disimpan pada peranti atau pelayar ini sahaja. '
                'Memadam data aplikasi atau pelayar turut memadam rekod.',
              ),
            ],
          );
        },
      ),
    ],
  );
}

class StatisticsSummary extends StatelessWidget {
  const StatisticsSummary({required this.statistics, super.key});
  final RecordStatistics statistics;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      _metric(context, 'Percubaan', '${statistics.count}'),
      _metric(
        context,
        'Skor terbaik',
        '${statistics.best.toStringAsFixed(1)}%',
      ),
      _metric(
        context,
        'Purata skor',
        '${statistics.average.toStringAsFixed(1)}%',
      ),
      _metric(context, 'Bab dicuba', '${statistics.chapters}'),
    ],
  );

  Widget _metric(BuildContext context, String label, String value) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    ),
  );
}
