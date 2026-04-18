import 'package:flutter/material.dart';

import '../models/award_item.dart';
import '../models/awards_summary.dart';

/// Seed awards + summary; swap for API/persistence later without layout changes.
class AwardsCatalog extends ChangeNotifier {
  AwardsCatalog()
      : summary = _seedSummary,
        awards = List<AwardItem>.unmodifiable(_seedAwards);

  AwardsSummary summary;
  final List<AwardItem> awards;

  /// Optional: call when counts change from backend.
  void updateSummary(AwardsSummary next) {
    summary = next;
    notifyListeners();
  }

  static const AwardsSummary _seedSummary = AwardsSummary(
    headline: 'Super Collector!',
    unlockedCount: 3,
    totalCount: 10,
  );

  static const List<AwardItem> _seedAwards = [
    AwardItem(
      id: 'star_matcher',
      title: 'Star Matcher',
      description: 'Completed 10 matches!',
      icon: Icons.military_tech_rounded,
      accent: AwardAccent.primary,
      isUnlocked: true,
    ),
    AwardItem(
      id: 'speedy_solver',
      title: 'Speedy Solver',
      description: 'Under 30 seconds!',
      icon: Icons.speed_rounded,
      accent: AwardAccent.secondary,
      isUnlocked: true,
    ),
    AwardItem(
      id: 'big_heart',
      title: 'Big Heart',
      description: 'Helped 5 friends!',
      icon: Icons.favorite_rounded,
      accent: AwardAccent.tertiary,
      isUnlocked: true,
    ),
    AwardItem(
      id: 'moon_explorer',
      title: 'Moon Explorer',
      description: '',
      icon: Icons.rocket_launch_rounded,
      accent: AwardAccent.neutral,
      isUnlocked: false,
      progressCurrent: 3,
      progressMax: 5,
    ),
    AwardItem(
      id: 'grand_champion',
      title: 'Grand Champion',
      description: 'Finish all levels',
      icon: Icons.emoji_events_rounded,
      accent: AwardAccent.neutral,
      isUnlocked: false,
      descriptionItalic: true,
    ),
    AwardItem(
      id: 'logic_master',
      title: 'Logic Master',
      description: 'No errors in a game',
      icon: Icons.workspace_premium_rounded,
      accent: AwardAccent.neutral,
      isUnlocked: false,
      descriptionItalic: true,
    ),
  ];
}
