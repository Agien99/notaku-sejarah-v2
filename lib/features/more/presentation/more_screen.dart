import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../records/data/records_repository.dart';
import '../application/app_settings_controller.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({
    required this.settingsController,
    this.recordsRepository,
    super.key,
  });

  final AppSettingsController settingsController;
  final RecordsRepository? recordsRepository;

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  RecordsRepository get _recordsRepository =>
      widget.recordsRepository ?? RecordsRepository.instance;

  @override
  void initState() {
    super.initState();
    _recordsRepository.addListener(_handleRecordsChanged);
    _recordsRepository.load();
  }

  @override
  void didUpdateWidget(MoreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldRepository =
        oldWidget.recordsRepository ?? RecordsRepository.instance;
    if (oldRepository != _recordsRepository) {
      oldRepository.removeListener(_handleRecordsChanged);
      _recordsRepository.addListener(_handleRecordsChanged);
      _recordsRepository.load();
    }
  }

  @override
  void dispose() {
    _recordsRepository.removeListener(_handleRecordsChanged);
    super.dispose();
  }

  void _handleRecordsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _confirmClearRecords() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline_rounded),
          title: const Text('Padam semua rekod kuiz?'),
          content: const Text(
            'Semua sejarah percubaan kuiz dan statistik yang disimpan '
            'akan dipadam. Tindakan ini tidak boleh dibuat asal.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Padam rekod'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true || !mounted) {
      return;
    }

    try {
      await _recordsRepository.clear();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua rekod kuiz telah dipadam.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rekod tidak dapat dipadam. Cuba semula.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasRecords = _recordsRepository.records.isNotEmpty;

    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (context, _) {
        return Column(
          key: const ValueKey('screen-lagi-content'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _PageHeader(),
            const SizedBox(height: AppSpacing.xl),
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth >= 760;

                if (!useTwoColumns) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SettingsCard(
                        settingsController: widget.settingsController,
                        hasRecords: hasRecords,
                        onClearRecords: _confirmClearRecords,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _AboutCard(),
                      const SizedBox(height: AppSpacing.lg),
                      const _CreditsCard(),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _SettingsCard(
                        settingsController: widget.settingsController,
                        hasRecords: hasRecords,
                        onClearRecords: _confirmClearRecords,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    const Expanded(
                      child: Column(
                        children: [
                          _AboutCard(),
                          SizedBox(height: AppSpacing.lg),
                          _CreditsCard(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tune_rounded, color: AppColors.goldSoft, size: 32),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Lagi',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: AppColors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Urus tetapan aplikasi dan lihat maklumat Notaku Sejarah.',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.goldSoft),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.settingsController,
    required this.hasRecords,
    required this.onClearRecords,
  });

  final AppSettingsController settingsController;
  final bool hasRecords;
  final VoidCallback onClearRecords;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      key: const ValueKey('settings-section'),
      icon: Icons.settings_outlined,
      title: 'Tetapan',
      subtitle: 'Sesuaikan pengalaman membaca dan urus data tempatan.',
      children: [
        Text(
          'Saiz teks aplikasi',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Perubahan digunakan terus pada paparan aplikasi.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<AppTextSize>(
            key: const ValueKey('text-size-selector'),
            segments: [
              for (final value in AppTextSize.values)
                ButtonSegment<AppTextSize>(
                  value: value,
                  label: Text(value.label),
                ),
            ],
            selected: {settingsController.textSize},
            onSelectionChanged: (selection) {
              settingsController.setTextSize(selection.first);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Divider(),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Rekod kuiz',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          hasRecords
              ? 'Padam semua percubaan kuiz dan statistik yang disimpan.'
              : 'Tiada rekod kuiz disimpan pada masa ini.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          key: const ValueKey('clear-records-button'),
          onPressed: hasRecords ? onClearRecords : null,
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Padam semua rekod'),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      key: const ValueKey('about-section'),
      icon: Icons.info_outline_rounded,
      title: 'Tentang',
      subtitle: 'Maklumat aplikasi dan tujuan pembelajaran.',
      children: [
        const _BrandMark(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Notaku Sejarah membantu pelajar mengulang kaji Sejarah melalui '
          'nota berstruktur, kuiz interaktif dan rekod kemajuan.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        const _InfoRow(label: 'Versi', value: '0.1.0 (Build 1)'),
        const SizedBox(height: AppSpacing.sm),
        const _InfoRow(label: 'Kurikulum', value: 'KSSM 2026'),
      ],
    );
  }
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      key: const ValueKey('credits-section'),
      icon: Icons.workspace_premium_outlined,
      title: 'Kredit',
      subtitle: 'Pembangunan dan teknologi yang digunakan.',
      children: [
        const _InfoRow(
          label: 'Dibangunkan oleh',
          value: 'Eurgien Anak Anthony',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _InfoRow(label: 'Teknologi', value: 'Flutter & Dart'),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Direka untuk pengalaman pembelajaran Sejarah yang moden, '
          'responsif dan mudah digunakan pada telefon serta tablet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.md),
                    ),
                  ),
                  child: Icon(icon, color: AppColors.navy),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: AppColors.goldSoft,
            size: 29,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOTAKU SEJARAH',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'MODERN HERITAGE',
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppColors.royalBlue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
