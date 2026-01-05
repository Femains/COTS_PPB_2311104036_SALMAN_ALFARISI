import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle subHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
