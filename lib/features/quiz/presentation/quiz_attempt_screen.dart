import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/quiz_repository.dart';
import '../domain/models/quiz_question.dart';
import '../domain/quiz_session.dart';

class QuizAttemptScreen extends StatefulWidget {
  const QuizAttemptScreen({
    required this.form,
    required this.chapter,
    required this.title,
    required this.repository,
    super.key,
  });

  final int form;
  final int chapter;
  final String title;
  final QuizRepository repository;

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  final _scrollController = ScrollController();
  QuizSession? _session;
  List<QuizQuestion>? _bank;
  String? _error;
  bool _loading = true;
  bool _allowExit = false;
  bool _dialogOpen = false;
  bool _review = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bank = await widget.repository.getQuestions(
        form: widget.form,
        chapter: widget.chapter,
      );
      if (!mounted) return;
      setState(() {
        _bank = bank;
        _loading = false;
        if (bank.length < QuizSession.questionCount) {
          _error =
              'Bank soalan belum mencukupi. Kuiz memerlukan sekurang-kurangnya '
              '${QuizSession.questionCount} soalan.';
        } else {
          _session = QuizSession(bank);
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Soalan tidak dapat dimuatkan. Sila cuba lagi.';
      });
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  Future<void> _exit() async {
    if (_dialogOpen) return;
    if (_session != null && !_session!.isSubmitted) {
      _dialogOpen = true;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Keluar daripada kuiz?'),
          content: const Text('Jawapan sesi ini akan hilang jika anda keluar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Teruskan kuiz'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Keluar'),
            ),
          ],
        ),
      );
      _dialogOpen = false;
      if (!mounted || confirmed != true) return;
    }
    if (!mounted) return;
    setState(() => _allowExit = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _submit() async {
    final session = _session!;
    if (!session.isComplete || session.isSubmitted || _dialogOpen) return;
    _dialogOpen = true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hantar jawapan?'),
        content: Text(
          'Anda telah menjawab semua ${session.questions.length} soalan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Semak dahulu'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hantar'),
          ),
        ],
      ),
    );
    _dialogOpen = false;
    if (!mounted || confirmed != true) return;
    setState(session.submit);
    _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    return PopScope<void>(
      canPop: _allowExit || session == null || session.isSubmitted,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Kembali',
            onPressed: _exit,
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text('Tingkatan ${widget.form} • Bab ${widget.chapter}'),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(24),
                      child: _error != null
                          ? Column(
                              children: [
                                const Icon(Icons.info_outline, size: 48),
                                const SizedBox(height: 16),
                                Text(_error!),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: _load,
                                  child: const Text('Cuba lagi'),
                                ),
                              ],
                            )
                          : session!.isSubmitted
                          ? _result(session)
                          : _question(session),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _question(QuizSession session) {
    final question = session.questions[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Soalan ${_index + 1} daripada ${session.questions.length}'),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: session.answeredCount / session.questions.length,
          semanticsLabel: 'Kemajuan jawapan',
          semanticsValue:
              '${session.answeredCount} daripada ${session.questions.length}',
        ),
        const SizedBox(height: 8),
        Text('${session.answeredCount}/${session.questions.length} dijawab'),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              question.prompt,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < question.options.length; i++) ...[
          Semantics(
            selected: session.answerFor(question) == question.options[i].id,
            child: OutlinedButton(
              key: ValueKey('answer-$i'),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor:
                    session.answerFor(question) == question.options[i].id
                    ? AppColors.goldSoft
                    : AppColors.surface,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () => setState(
                () => session.answer(_index, question.options[i].id),
              ),
              child: Row(
                children: [
                  Icon(
                    session.answerFor(question) == question.options[i].id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${String.fromCharCode(65 + i)}. ${question.options[i].text}',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton(
              onPressed: _index == 0 ? null : () => _goTo(_index - 1),
              child: const Text('Sebelumnya'),
            ),
            if (_index < session.questions.length - 1)
              FilledButton(
                onPressed: () => _goTo(_index + 1),
                child: const Text('Seterusnya'),
              ),
            FilledButton(
              onPressed: session.isComplete ? _submit : null,
              child: const Text('Hantar jawapan'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Navigasi soalan • Tanda ✓ bermaksud sudah dijawab'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < session.questions.length; i++)
              ChoiceChip(
                key: ValueKey('question-$i'),
                label: Text(
                  '${i + 1}${session.answerFor(session.questions[i]) == null ? '' : ' ✓'}',
                ),
                selected: _index == i,
                showCheckmark: false,
                onSelected: (_) => _goTo(i),
              ),
          ],
        ),
        if (!session.isComplete) ...[
          const SizedBox(height: 12),
          const Text('Jawab semua soalan untuk menghantar kuiz.'),
        ],
      ],
    );
  }

  void _goTo(int index) {
    setState(() => _index = index);
    _scrollToTop();
  }

  Widget _result(QuizSession session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.workspace_premium_outlined,
          size: 64,
          color: AppColors.gold,
        ),
        const SizedBox(height: 16),
        Text(
          'Keputusan Kuiz',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(widget.title),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '${session.percentage}%',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text('${session.score} / ${session.questions.length} betul'),
                const SizedBox(height: 8),
                Text('${session.questions.length - session.score} salah'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () => setState(() => _review = !_review),
              child: Text(_review ? 'Tutup semakan' : 'Semak jawapan'),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _session = QuizSession(_bank!);
                  _index = 0;
                  _review = false;
                });
                _scrollToTop();
              },
              child: const Text('Cuba semula'),
            ),
            TextButton(onPressed: _exit, child: const Text('Kembali ke bab')),
          ],
        ),
        if (_review) ...[
          const SizedBox(height: 24),
          for (var i = 0; i < session.questions.length; i++) ...[
            _reviewCard(session, i),
            const SizedBox(height: 16),
          ],
        ],
      ],
    );
  }

  Widget _reviewCard(QuizSession session, int index) {
    final question = session.questions[index];
    final selected = question.options.singleWhere(
      (option) => option.id == session.answerFor(question),
    );
    final correct = selected.id == question.correctOptionId;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${question.prompt}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              correct ? '✓ Betul' : '✗ Salah',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Jawapan anda: ${selected.text}'),
            Text('Jawapan betul: ${question.correctOption.text}'),
            const SizedBox(height: 12),
            Text(question.explanation),
          ],
        ),
      ),
    );
  }
}
