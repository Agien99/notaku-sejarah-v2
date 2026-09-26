import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../records/presentation/records_builder.dart';
import '../../../records/presentation/record_detail_screen.dart';
import 'utama_empty_state_card.dart';
import 'utama_section_header.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('section-aktiviti-terkini'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UtamaSectionHeader(
          title: 'Aktiviti Terkini',
          subtitle: 'Aktiviti pembelajaran terbaru akan muncul di sini.',
        ),
        const SizedBox(height: AppSpacing.md),
        RecordsBuilder(
          builder: (context, repository) {
            if (repository.records.isNotEmpty) {
              return Column(
                children: [
                  for (final record in repository.records.take(3))
                    RecordTile(record: record),
                ],
              );
            }
            return const UtamaEmptyStateCard(
              key: ValueKey('recent-activity-empty'),
              icon: Icons.timeline_rounded,
              title: 'Belum ada aktiviti terkini',
              description:
                  'Selesaikan kuiz untuk melihat aktiviti terbaru di sini.',
            );
          },
        ),
      ],
    );
  }
}
