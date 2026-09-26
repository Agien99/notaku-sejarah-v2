import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../records/presentation/records_builder.dart';
import '../../../records/presentation/record_detail_screen.dart';
import 'utama_empty_state_card.dart';
import 'utama_section_header.dart';

class LatestPerformanceSection extends StatelessWidget {
  const LatestPerformanceSection({required this.onStartQuiz, super.key});

  final VoidCallback onStartQuiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('section-prestasi-terkini'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UtamaSectionHeader(
          title: 'Prestasi Terkini',
          subtitle: 'Ringkasan keputusan kuiz terbaru anda.',
        ),
        const SizedBox(height: AppSpacing.md),
        RecordsBuilder(
          builder: (context, repository) {
            if (repository.records.isNotEmpty) {
              return RecordTile(record: repository.records.first);
            }
            return UtamaEmptyStateCard(
              key: const ValueKey('latest-performance-empty'),
              icon: Icons.insights_outlined,
              title: 'Belum ada keputusan kuiz',
              description:
                  'Selesaikan kuiz pertama anda untuk melihat prestasi terkini '
                  'di sini.',
              actionLabel: 'Mulakan Kuiz',
              onAction: onStartQuiz,
            );
          },
        ),
      ],
    );
  }
}
