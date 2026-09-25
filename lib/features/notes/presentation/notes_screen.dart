import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      eyebrow: 'NOTA',
      title: 'Nota Sejarah',
      description:
          'Pilih tingkatan dan bab untuk mula membaca nota Sejarah apabila '
          'modul kandungan dibina.',
      icon: Icons.menu_book_rounded,
    );
  }
}
