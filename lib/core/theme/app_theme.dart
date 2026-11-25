import 'package:flutter/material.dart';

/// ثيم التطبيق. لون واحد أساسي والباقي يتولّد منه (Material 3).
class AppTheme {
  const AppTheme._();

  static const seedColor = Color(0xFF0F766E);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: seedColor);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );
  }
}
