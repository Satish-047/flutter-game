import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/gummy_layout.dart';

enum GummyTab { games, awards, settings }

/// Frosted bottom bar — active tab gets gold pill (mockup match).
class GummyBottomNav extends StatelessWidget {
  const GummyBottomNav({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final GummyTab current;
  final ValueChanged<GummyTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(GummyLayout.navRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest.withValues(alpha: 0.62),
            boxShadow: [
              BoxShadow(
                color: scheme.secondary.withValues(alpha: 0.08),
                blurRadius: 40,
                offset: const Offset(0, -12),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavCell(
                  icon: Icons.videogame_asset_rounded,
                  label: 'Games',
                  selected: current == GummyTab.games,
                  onTap: () => onSelect(GummyTab.games),
                ),
                _NavCell(
                  icon: Icons.emoji_events_rounded,
                  label: 'Awards',
                  selected: current == GummyTab.awards,
                  onTap: () => onSelect(GummyTab.awards),
                ),
                _NavCell(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  selected: current == GummyTab.settings,
                  onTap: () => onSelect(GummyTab.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bg = selected ? scheme.primaryContainer : Colors.transparent;
    final fg = selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(999),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.38),
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 26, color: fg),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: fg,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
