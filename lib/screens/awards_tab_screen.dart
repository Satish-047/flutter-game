import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/award_item.dart';
import '../models/awards_summary.dart';
import '../state/awards_catalog.dart';
import '../theme/clay_shadows.dart';
import '../theme/gummy_layout.dart';

/// Awards tab body only — shell header + bottom nav stay in [MainShell].
class AwardsTabScreen extends StatelessWidget {
  const AwardsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Consumer<AwardsCatalog>(
          builder: (context, catalog, _) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    GummyLayout.pagePaddingH,
                    GummyLayout.blockGap,
                    GummyLayout.pagePaddingH,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _ProgressHeroCard(summary: catalog.summary),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: GummyLayout.sectionGap)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    GummyLayout.pagePaddingH,
                    0,
                    GummyLayout.pagePaddingH,
                    120,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: GummyLayout.gridGap,
                      crossAxisSpacing: GummyLayout.gridGap,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = catalog.awards[index];
                        return _AwardTile(item: item);
                      },
                      childCount: catalog.awards.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const _FloatingDecor(),
      ],
    );
  }
}

class _ProgressHeroCard extends StatelessWidget {
  const _ProgressHeroCard({required this.summary});

  final AwardsSummary summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
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
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -16,
            top: -16,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primaryContainer.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
          Positioned(
            right: -32,
            bottom: -32,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.secondaryContainer.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                summary.headline,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                summary.subcopy,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 22,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(color: scheme.surfaceContainerHigh),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: summary.progressFraction.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      scheme.primary,
                                      scheme.primaryContainer,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.primary.withValues(alpha: 0.35),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    '${summary.progressPercentRounded}%',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AwardTile extends StatelessWidget {
  const _AwardTile({required this.item});

  final AwardItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!item.isUnlocked) {
      final lockedOpacity = item.showsProgressBar ? 0.85 : 0.72;
      return Opacity(
        opacity: lockedOpacity,
        child: _LockedAwardCard(item: item),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
        boxShadow: ClayShadows.ambient(scheme.primary, y: 12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _UnlockedIconCircle(item: item),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnlockedIconCircle extends StatelessWidget {
  const _UnlockedIconCircle({required this.item});

  final AwardItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = _accentBg(scheme, item.accent);
    final fg = _accentFg(scheme, item.accent);

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.55),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: fg.withValues(alpha: 0.12),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(item.icon, size: 44, color: fg),
    );
  }
}

class _LockedAwardCard extends StatelessWidget {
  const _LockedAwardCard({required this.item});

  final AwardItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(8, 8),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            offset: const Offset(4, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.lock_rounded, size: 20, color: scheme.onSurfaceVariant),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surfaceContainerHigh,
                ),
                child: Icon(
                  item.icon,
                  size: 44,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (item.showsProgressBar) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 8,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: scheme.surfaceContainerHighest),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: item.progress01,
                          child: Container(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.progressCurrent}/${item.progressMax} matches',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 6),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.72),
                    fontStyle:
                        item.descriptionItalic ? FontStyle.italic : FontStyle.normal,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

Color _accentBg(ColorScheme scheme, AwardAccent accent) {
  switch (accent) {
    case AwardAccent.primary:
      return scheme.primaryContainer;
    case AwardAccent.secondary:
      return scheme.secondaryContainer;
    case AwardAccent.tertiary:
      return scheme.tertiaryContainer;
    case AwardAccent.neutral:
      return scheme.surfaceContainerHigh;
  }
}

Color _accentFg(ColorScheme scheme, AwardAccent accent) {
  switch (accent) {
    case AwardAccent.primary:
      return scheme.primary;
    case AwardAccent.secondary:
      return scheme.secondary;
    case AwardAccent.tertiary:
      return scheme.tertiary;
    case AwardAccent.neutral:
      return scheme.onSurfaceVariant;
  }
}

/// Low-opacity emoji accents (mockup) — decorative, non-interactive.
class _FloatingDecor extends StatelessWidget {
  const _FloatingDecor();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.18,
            left: -8,
            child: Transform.rotate(
              angle: 0.2,
              child: Opacity(
                opacity: 0.38,
                child: Text('✨', style: TextStyle(fontSize: 34)),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * 0.28,
            right: -12,
            child: Transform.rotate(
              angle: -0.2,
              child: Opacity(
                opacity: 0.28,
                child: Text('😊', style: TextStyle(fontSize: 42)),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.42,
            right: 16,
            child: Opacity(
              opacity: 0.18,
              child: Text('⭐', style: TextStyle(fontSize: 26)),
            ),
          ),
        ],
      ),
    );
  }
}
