import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gummy_color_scheme.dart';

/// Central app theme — colors, typography roles, shape defaults (squish radii).
ThemeData buildGummyCloudTheme({required Brightness brightness}) {
  final scheme =
      brightness == Brightness.dark ? GummyColorScheme.dark() : GummyColorScheme.light();

  final jakarta = GoogleFonts.plusJakartaSansTextTheme;
  final vietnam = GoogleFonts.beVietnamProTextTheme;

  TextTheme mergeLabels(TextTheme base) {
    final v = vietnam(base);
    return base.copyWith(
      labelLarge: v.labelLarge,
      labelMedium: v.labelMedium,
      labelSmall: v.labelSmall,
      bodySmall: v.bodySmall?.copyWith(
        letterSpacing: 0.15,
      ),
    );
  }

  final textTheme = mergeLabels(
    jakarta(
      brightness == Brightness.dark
          ? Typography.whiteMountainView
          : Typography.blackMountainView,
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    textTheme: textTheme,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: scheme.primary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 80,
      backgroundColor: scheme.surfaceContainerLowest.withValues(alpha: 0.72),
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((s) {
        final w = s.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w700;
        return GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: w,
          letterSpacing: 0.2,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          size: 26,
          color: s.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        textStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.transparent,
      thickness: 0,
      space: 0,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return scheme.surfaceContainerLowest;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return scheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
