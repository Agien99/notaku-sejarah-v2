import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const display = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.6,
  );

  static const headline = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const label = TextStyle(
    color: AppColors.navy,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.6,
  );
}
