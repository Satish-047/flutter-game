import 'package:flutter/material.dart';

/// Shared placeholder for every hub game until real modes ship.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.gameTitle,
    this.gameId,
    this.subtitle,
  });

  final String gameTitle;
  final String? gameId;

  /// Shown under the headline when non-null (e.g. unreleased Puzzle).
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(gameTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Semantics(
            label:
                '$gameTitle — coming soon${gameId != null ? ' ($gameId)' : ''}',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$gameTitle — coming soon',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
