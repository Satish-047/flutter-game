import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/clay_shadows.dart';
import '../theme/gummy_layout.dart';

/// Shared celebratory layout (Quiz, future modes, …) matching game-over mockup structure.
class SessionResultsBody extends StatelessWidget {
  const SessionResultsBody({
    super.key,
    required this.score,
    required this.passed,
    required this.bannerPass,
    required this.bannerFail,
    required this.chips,
    required this.onPrimary,
    this.primaryLabel = 'Play Again',
    this.hero = const _DefaultTrophyHero(),
  });

  final int score;
  final bool passed;

  /// Uppercase banner when [passed] is true (e.g. YOU WIN!).
  final String bannerPass;

  /// When failed (e.g. KEEP TRYING!).
  final String bannerFail;

  final List<ResultStatChipData> chips;
  final VoidCallback onPrimary;
  final String primaryLabel;

  /// Replace with mode-specific art if needed.
  final Widget hero;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bannerText = passed ? bannerPass : bannerFail;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        GummyLayout.pagePaddingH,
        16,
        GummyLayout.pagePaddingH,
        32,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(GummyLayout.clayRadiusLg),
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.2,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.85),
              scheme.surface,
              scheme.secondaryContainer.withValues(alpha: 0.55),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -8,
              top: 0,
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  Icons.star_rounded,
                  size: 120,
                  color: scheme.primary,
                ),
              ),
            ),
            Positioned(
              right: -16,
              bottom: 120,
              child: Opacity(
                opacity: 0.18,
                child: Icon(
                  Icons.celebration_rounded,
                  size: 100,
                  color: scheme.tertiary,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 8),
                hero,
                const SizedBox(height: 28),
                Transform.rotate(
                  angle: -0.035,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.tertiary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        ...ClayShadows.ambient(scheme.tertiary, y: 8),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: -8,
                          top: -12,
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 36,
                            color: scheme.primaryContainer,
                          ),
                        ),
                        Text(
                          bannerText,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: scheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLowest,
                    borderRadius:
                        BorderRadius.circular(GummyLayout.clayRadiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.08),
                        blurRadius: 40,
                        offset: const Offset(12, 12),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.4),
                        offset: const Offset(4, 4),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.1),
                        offset: const Offset(-4, -4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Score',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.military_tech_rounded,
                            size: 44,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$score',
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: scheme.primary,
                              fontSize: 56,
                              height: 1,
                              shadows: [
                                Shadow(
                                  color:
                                      scheme.primary.withValues(alpha: 0.25),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          for (var i = 0; i < chips.length; i++) ...[
                            if (i > 0) const SizedBox(width: 12),
                            Expanded(
                              child: ResultStatChip(data: chips[i]),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: onPrimary,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(GummyLayout.clayRadiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay_rounded, color: scheme.onPrimary),
                      const SizedBox(width: 10),
                      Text(
                        primaryLabel,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultTrophyHero extends StatelessWidget {
  const _DefaultTrophyHero();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.22),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.surfaceContainerLowest,
            boxShadow: ClayShadows.ambient(scheme.primary, y: 16),
          ),
          child: Icon(
            Icons.emoji_events_rounded,
            size: 112,
            color: scheme.primary,
          ),
        ),
      ],
    );
  }
}

class ResultStatChipData {
  const ResultStatChipData({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final Color iconColor;
}

class ResultStatChip extends StatelessWidget {
  const ResultStatChip({super.key, required this.data});

  final ResultStatChipData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(data.icon, color: data.iconColor, size: 28),
          const SizedBox(height: 6),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: data.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

String formatSessionDuration(Duration d) {
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return '$m:${s.toString().padLeft(2, '0')}';
}
