import 'package:flutter/material.dart';

enum AwardAccent {
  primary,
  secondary,
  tertiary,
  neutral,
}

/// Single tile in the awards grid — add rows by extending seed data only.
class AwardItem {
  const AwardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.isUnlocked,
    this.progressCurrent,
    this.progressMax,
    this.descriptionItalic = false,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AwardAccent accent;
  final bool isUnlocked;

  /// When set with [isUnlocked] false, shows thin progress + “x/y …” (Moon Explorer).
  final int? progressCurrent;
  final int? progressMax;

  /// Muted italic hint for fully locked cards (Grand Champion, Logic Master).
  final bool descriptionItalic;

  bool get showsProgressBar =>
      !isUnlocked &&
      progressMax != null &&
      progressMax! > 0 &&
      (progressCurrent ?? 0) >= 0;

  double get progress01 {
    if (progressMax == null || progressMax! <= 0) return 0;
    return ((progressCurrent ?? 0) / progressMax!).clamp(0.0, 1.0);
  }
}
