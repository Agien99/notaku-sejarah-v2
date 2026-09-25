import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'utama_empty_state_card.dart';
import 'utama_section_header.dart';

class ContinueLearningSection extends StatelessWidget {
  const ContinueLearningSection({required this.onStartNotes, super.key});

  final VoidCallback onStartNotes;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('section-sambung-belajar'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UtamaSectionHeader(
          title: 'Sambung Belajar',
          subtitle: 'Teruskan dari tempat terakhir anda berhenti.',
        ),
        const SizedBox(height: AppSpacing.md),
        UtamaEmptyStateCard(
          key: const ValueKey('continue-learning-empty'),
          icon: Icons.bookmark_outline_rounded,
          title: 'Belum ada pembelajaran untuk disambung',
          description:
              'Mulakan dengan nota pertama anda. Kemajuan pembelajaran akan '
              'dipaparkan di sini nanti.',
          actionLabel: 'Mula dengan Nota',
          onAction: onStartNotes,
        ),
      ],
    );
  }
}
