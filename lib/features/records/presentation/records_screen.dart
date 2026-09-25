import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      eyebrow: 'REKOD',
      title: 'Rekod pembelajaran',
      description:
          'Sejarah kuiz, markah dan kemajuan pembelajaran anda akan '
          'dikumpulkan di halaman ini.',
      icon: Icons.history_rounded,
    );
  }
}
