/// Quiz scoring rules — single place to tune points, timers, and pass criteria.
///
/// **Timer:** Each question has its own countdown ([perQuestionLimit]). When it
/// expires before the player taps an answer, that question is scored as wrong and
/// [pointsWrongOrTimeout] applies. There is no separate global session cap in MVP.
abstract final class QuizScoring {
  static const int pointsPerCorrect = 10;

  /// Wrong answer or per-question timeout (no negative points in MVP).
  static const int pointsWrongOrTimeout = 0;

  static const int questionsPerRun = 5;

  /// Per-question timer — visible as linear progress + numeric countdown.
  static const Duration perQuestionLimit = Duration(seconds: 18);

  static const int maxScore = questionsPerRun * pointsPerCorrect;

  /// Pass / fail split for results banner (default 60% of [maxScore]).
  static const int minimumScoreToPass = 30;

  /// Total time spent on questions (answer or timeout) under this → "Fast" chip.
  static const Duration fastSessionThreshold = Duration(seconds: 70);
}
