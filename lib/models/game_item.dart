import 'package:flutter/material.dart';

/// One row in the games hub grid (`buildDefaultGameItems` in `game_catalog.dart`).
class GameItem {
  GameItem({
    required this.id,
    required this.title,
    required this.tileBackground,
    this.imageUrl,
    this.placeholderIcon,
    this.selected = false,
    this.comingSoonSubtitle,
  }) : assert(
          (imageUrl?.isNotEmpty ?? false) || placeholderIcon != null,
        );

  final String id;
  final String title;

  /// Remote art for the circular tile; when null, [placeholderIcon] is shown.
  final String? imageUrl;
  final IconData? placeholderIcon;

  final Color tileBackground;
  final bool selected;

  /// Optional line below “title — coming soon” on [ComingSoonScreen].
  final String? comingSoonSubtitle;
}
