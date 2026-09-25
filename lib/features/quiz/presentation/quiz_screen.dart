import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      eyebrow: 'KUIZ',
      title: 'Uji kefahaman anda',
      description:
          'Kuiz mengikut tingkatan dan bab akan tersedia di sini dalam '
          'fasa pembangunan kuiz.',
      icon: Icons.quiz_rounded,
    );
  }
}
