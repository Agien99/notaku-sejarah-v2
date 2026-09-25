import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'utama_empty_state_card.dart';
import 'utama_section_header.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('section-aktiviti-terkini'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UtamaSectionHeader(
          title: 'Aktiviti Terkini',
          subtitle: 'Aktiviti pembelajaran terbaru akan muncul di sini.',
        ),
        SizedBox(height: AppSpacing.md),
        UtamaEmptyStateCard(
          key: ValueKey('recent-activity-empty'),
          icon: Icons.timeline_rounded,
          title: 'Belum ada aktiviti terkini',
          description:
              'Apabila anda mula membaca nota atau menjawab kuiz, aktiviti '
              'terbaru akan direkodkan di sini.',
        ),
      ],
    );
  }
}
