/// Overall awards progress shown in the hero card (dynamic copy from counts).
class AwardsSummary {
  const AwardsSummary({
    required this.headline,
    required this.unlockedCount,
    required this.totalCount,
  });

  final String headline;
  final int unlockedCount;
  final int totalCount;

  /// 0.0–1.0 for the chunky progress bar (mockup: 3/10 → 30%).
  double get progressFraction =>
      totalCount > 0 ? unlockedCount / totalCount : 0;

  int get progressPercentRounded =>
      (progressFraction * 100).round().clamp(0, 100);

  String get subcopy =>
      "You've unlocked $unlockedCount out of $totalCount special awards.";
}
