import 'package:flutter/material.dart';

import '../data/game_catalog.dart';
import '../models/game_item.dart';
import '../models/featured_challenge.dart';
import '../theme/clay_shadows.dart';
import '../theme/gummy_layout.dart';
import '../quiz/quiz_flow_screen.dart';
import 'coming_soon_screen.dart';

/// Games hub — subtitle, 2×2 grid, featured “New Challenge” block (mockup structure).
class GamesTabScreen extends StatelessWidget {
  const GamesTabScreen({super.key});

  void _openGame(BuildContext context, GameItem item) {
    if (item.id == 'quiz') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (context) => const QuizFlowScreen(),
        ),
      );
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ComingSoonScreen(
          gameTitle: item.title,
          gameId: item.id,
          subtitle: item.comingSoonSubtitle,
        ),
      ),
    );
  }

  void _openFeatured(BuildContext context, FeaturedChallenge f) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${f.ctaLabel}: next event — coming soon',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final items = buildDefaultGameItems(scheme);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: GummyLayout.pagePaddingH,
        right: GummyLayout.pagePaddingH,
        bottom: 120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: GummyLayout.sectionGap),
          Text(
            'Which adventure will you join today?',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: GummyLayout.sectionGap),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: GummyLayout.gridGap,
              crossAxisSpacing: GummyLayout.gridGap,
              childAspectRatio: 0.82,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _GameCircleTile(
                item: item,
                onTap: () => _openGame(context, item),
              );
            },
          ),
          const SizedBox(height: GummyLayout.sectionGap),
          _FeaturedChallengeCard(
            challenge: kDefaultFeaturedChallenge,
            onCta: () => _openFeatured(context, kDefaultFeaturedChallenge),
          ),
        ],
      ),
    );
  }
}

class _GameCircleTile extends StatelessWidget {
  const _GameCircleTile({
    required this.item,
    required this.onTap,
  });

  final GameItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final outerShadow = item.selected
        ? [
            BoxShadow(
              color: scheme.primaryContainer,
              blurRadius: 0,
              spreadRadius: 8,
            ),
            ...ClayShadows.ambient(scheme.primary, y: 12),
          ]
        : ClayShadows.ambient(scheme.shadow, y: 12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: scheme.primary.withValues(alpha: 0.12),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.tileBackground,
                  boxShadow: outerShadow,
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.28),
                            ],
                          ),
                        ),
                      ),
                      if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                        Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.secondary,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              ColoredBox(
                            color: item.tileBackground,
                            child: Icon(
                              Icons.image_not_supported_rounded,
                              color: scheme.onSurfaceVariant,
                              size: 40,
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Icon(
                            item.placeholderIcon!,
                            size: 56,
                            color: _iconOnTileBackground(
                              scheme,
                              item.tileBackground,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
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
                color: item.selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _iconOnTileBackground(ColorScheme scheme, Color background) {
  if (background == scheme.primaryContainer) {
    return scheme.onPrimaryContainer;
  }
  if (background == scheme.secondaryContainer) {
    return scheme.onSecondaryContainer;
  }
  if (background == scheme.tertiaryContainer) {
    return scheme.onTertiaryContainer;
  }
  return scheme.onSurfaceVariant;
}

class _FeaturedChallengeCard extends StatelessWidget {
  const _FeaturedChallengeCard({
    required this.challenge,
    required this.onCta,
  });

  final FeaturedChallenge challenge;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 4,
        ),
        boxShadow: ClayShadows.ambient(scheme.secondary, y: 12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -8,
            top: -16,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 72,
              color: scheme.onSecondaryContainer.withValues(alpha: 0.22),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 220,
                child: Text(
                  challenge.body,
                  style: textTheme.bodyLarge?.copyWith(
                    color: scheme.onSecondaryContainer.withValues(alpha: 0.82),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                ),
                onPressed: onCta,
                child: Text(challenge.ctaLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
