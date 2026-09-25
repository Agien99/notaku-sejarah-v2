import 'package:flutter/material.dart';

import 'widgets/utama_header.dart';

class UtamaScreen extends StatelessWidget {
  const UtamaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UtamaHeader(),
      ],
    );
  }
}
