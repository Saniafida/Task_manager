// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/dark_theme.dart';
import 'package:task_manager/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.black),
        bodyMedium: TextStyle(color: AppColors.black),
      ),
    );
  }

  static ThemeData get darkTheme {
    return DarkTheme.darkTheme;
  }
}