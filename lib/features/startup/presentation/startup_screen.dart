import 'package:flutter/material.dart';

import '../../../core/branding/app_brand_mark.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onFinished();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('startup-screen'),
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide = constraints.biggest.shortestSide;
            final logoSize = shortestSide >= 600 ? 168.0 : 132.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBrandMark(size: logoSize),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'NOTAKU SEJARAH',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'MODERN HERITAGE',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.royalBlue,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.1,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SizedBox(
                          width: 88,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              return LinearProgressIndicator(
                                value: _controller.value,
                                minHeight: 3,
                                borderRadius: BorderRadius.circular(99),
                                backgroundColor: AppColors.goldSoft,
                                color: AppColors.gold,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
