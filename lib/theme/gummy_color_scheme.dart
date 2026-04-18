import 'package:flutter/material.dart';

/// Material 3-style palette aligned with `gummy_cloud/DESIGN.md` + mockup HTML.
abstract final class GummyColorScheme {
  static ColorScheme light() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF705D00),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFE170),
      onPrimaryContainer: Color(0xFF544600),
      secondary: Color(0xFF006493),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFCAE6FF),
      onSecondaryContainer: Color(0xFF004B70),
      tertiary: Color(0xFFBB0054),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFD9DF),
      onTertiaryContainer: Color(0xFF8F003F),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFF6FAFE),
      onSurface: Color(0xFF171C1F),
      surfaceContainerHighest: Color(0xFFDFE3E7),
      surfaceContainerHigh: Color(0xFFE4E9ED),
      surfaceContainer: Color(0xFFEAEEF2),
      surfaceContainerLow: Color(0xFFF0F4F8),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF4E462A),
      outline: Color(0xFF807757),
      outlineVariant: Color(0xFFD2C6A1),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2C3134),
      onInverseSurface: Color(0xFFEDF1F5),
      inversePrimary: Color(0xFFE9C400),
    );
  }

  /// Minimal dark stub — same brand hues, tuned surfaces (product can expand later).
  static ColorScheme dark() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFFE9C400),
      brightness: Brightness.dark,
      primary: const Color(0xFFE9C400),
      onPrimary: const Color(0xFF221B00),
      primaryContainer: const Color(0xFF544600),
      onPrimaryContainer: const Color(0xFFFFE170),
      secondary: const Color(0xFF8DCFF8),
      onSecondary: const Color(0xFF001E30),
      secondaryContainer: const Color(0xFF004B70),
      onSecondaryContainer: const Color(0xFFCAE6FF),
      tertiary: const Color(0xFFFFB1C8),
      onTertiary: const Color(0xFF3F0018),
      tertiaryContainer: const Color(0xFF8F003F),
      onTertiaryContainer: const Color(0xFFFFD9DF),
      surface: const Color(0xFF121418),
      onSurface: const Color(0xFFE4E9ED),
      surfaceContainerHighest: const Color(0xFF3D4449),
      surfaceContainerHigh: const Color(0xFF32393E),
      surfaceContainer: const Color(0xFF282E33),
      surfaceContainerLow: const Color(0xFF1F2529),
      surfaceContainerLowest: const Color(0xFF121418),
    );
  }
}
