import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'widgets/continue_learning_section.dart';
import 'widgets/latest_performance_section.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/utama_header.dart';

class UtamaScreen extends StatelessWidget {
  const UtamaScreen({
    required this.onOpenNotes,
    required this.onOpenQuiz,
    required this.onOpenRecords,
    super.key,
  });

  final VoidCallback onOpenNotes;
  final VoidCallback onOpenQuiz;
  final VoidCallback onOpenRecords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UtamaHeader(),
        const SizedBox(height: AppSpacing.xl),
        ContinueLearningSection(onStartNotes: onOpenNotes),
        const SizedBox(height: AppSpacing.xl),
        QuickActionsSection(
          onOpenNotes: onOpenNotes,
          onOpenQuiz: onOpenQuiz,
          onOpenRecords: onOpenRecords,
        ),
        const SizedBox(height: AppSpacing.xl),
        LayoutBuilder(
          builder: (context, constraints) {
            final useTwoColumns = constraints.maxWidth >= 680;

            if (!useTwoColumns) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LatestPerformanceSection(onStartQuiz: onOpenQuiz),
                  const SizedBox(height: AppSpacing.xl),
                  const RecentActivitySection(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LatestPerformanceSection(onStartQuiz: onOpenQuiz),
                ),
                const SizedBox(width: AppSpacing.lg),
                const Expanded(child: RecentActivitySection()),
              ],
            );
          },
        ),
      ],
    );
  }
}
