import 'package:flutter/material.dart';

import '../data/records_repository.dart';

class RecordsBuilder extends StatefulWidget {
  const RecordsBuilder({required this.builder, this.repository, super.key});
  final RecordsRepository? repository;
  final Widget Function(BuildContext, RecordsRepository) builder;

  @override
  State<RecordsBuilder> createState() => _RecordsBuilderState();
}

class _RecordsBuilderState extends State<RecordsBuilder> {
  late final _repository = widget.repository ?? RecordsRepository.instance;

  @override
  void initState() {
    super.initState();
    _repository.load();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _repository,
    builder: (context, _) {
      if (_repository.error != null) {
        return Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const Text('Rekod tidak dapat dimuatkan. Sila cuba lagi.'),
            TextButton(onPressed: _repository.load, child: const Text('Cuba lagi')),
          ]),
        ));
      }
      if (!_repository.loaded) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return widget.builder(context, _repository);
    },
  );
}
