import 'package:flutter/material.dart';

import '../theme/gummy_layout.dart';

/// Shared shell body for Awards / Settings until real content ships.
class ComingSoonTabScreen extends StatelessWidget {
  const ComingSoonTabScreen({
    super.key,
    required this.title,
    required this.message,
    this.subtitle,
  });

  final String title;
  final String message;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GummyLayout.pagePaddingH),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 56,
              color: scheme.secondary.withValues(alpha: 0.65),
            ),
            const SizedBox(height: GummyLayout.blockGap),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
