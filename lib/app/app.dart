import 'package:flutter/material.dart';

import '../features/foundation/presentation/foundation_screen.dart';

class NotakuSejarahApp extends StatelessWidget {
  const NotakuSejarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notaku Sejarah',
      debugShowCheckedModeBanner: false,
      home: const FoundationScreen(),
    );
  }
}
