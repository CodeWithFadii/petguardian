import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: const ColorScheme.light().copyWith(primary: AppColors.primary),
      primaryColor: AppColors.primary,
      fontFamily: 'Poppins',
      useMaterial3: true,
      appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      scaffoldBackgroundColor: AppColors.bg,
    );
  }
}
