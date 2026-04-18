import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/player_profile.dart';
import '../theme/gummy_layout.dart';

/// Clay-style top header: avatar · dynamic title · points pill (matches mockup).
class GummyTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GummyTopBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(
            left: GummyLayout.pagePaddingH,
            right: GummyLayout.pagePaddingH,
            top: MediaQuery.paddingOf(context).top + 8,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(GummyLayout.headerRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.45),
                offset: const Offset(4, 4),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              _AvatarBubble(colorScheme: scheme),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                    color: scheme.primary,
                  ),
                ),
              ),
              const _PointsPill(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.surfaceContainerLowest,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.55),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(-3, -3),
            blurRadius: 8,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            colorScheme.secondaryContainer,
            colorScheme.tertiaryContainer,
          ],
        ),
      ),
      child: Icon(
        Icons.face_retouching_natural_rounded,
        color: colorScheme.onSecondaryContainer,
        size: 28,
      ),
    );
  }
}

class _PointsPill extends StatelessWidget {
  const _PointsPill();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final profile = context.watch<PlayerProfile>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          profile.addPoints(10);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '+10 pts (demo)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onInverseSurface,
                    ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: scheme.inverseSurface,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.45),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            '${_formatPoints(profile.points)} pts',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onPrimaryContainer,
                ),
          ),
        ),
      ),
    );
  }
}

String _formatPoints(int n) {
  final s = n.toString();
  if (s.length <= 3) return s;
  return '${_formatPoints(int.parse(s.substring(0, s.length - 3)))},${s.substring(s.length - 3)}';
}
