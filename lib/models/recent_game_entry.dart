class RecentGameEntry {
  const RecentGameEntry({
    required this.id,
    required this.title,
    required this.scoreLabel,
    required this.timeLabel,
    required this.thumbnailUrl,
    this.newBest = false,
  });

  final String id;
  final String title;
  final String scoreLabel;
  final String timeLabel;
  final String thumbnailUrl;
  final bool newBest;
}
