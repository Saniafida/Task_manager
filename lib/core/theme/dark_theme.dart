// lib/core/theme/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_colors.dart';

class DarkTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.white),
      ),
    );
  }
}