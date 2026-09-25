import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

class UtamaScreen extends StatelessWidget {
  const UtamaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      eyebrow: 'UTAMA',
      title: 'Selamat datang ke Notaku Sejarah',
      description:
          'Ringkasan pembelajaran, sambung belajar, prestasi dan aktiviti '
          'terkini akan dipaparkan di halaman ini.',
      icon: Icons.home_rounded,
    );
  }
}
