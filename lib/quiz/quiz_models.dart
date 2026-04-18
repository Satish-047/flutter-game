import 'dart:math';

import 'quiz_scoring.dart';

/// Fixed topic metadata + exactly five base questions (bank per topic).
class QuizTopic {
  const QuizTopic({
    required this.id,
    required this.title,
    required this.emoji,
    this.description,
    required this.questions,
  }) : assert(questions.length == 5);

  final String id;
  final String title;
  final String emoji;
  final String? description;

  /// Authoring order; session layer shuffles copy + option order.
  final List<QuizQuestion> questions;
}

/// One MC question — [options] length 4, [correctIndex] points at the right answer.
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  }) : assert(options.length == 4);

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;

  /// Randomize answer order; keeps correctness aligned.
  QuizQuestion shuffled(Random rng) {
    final opts = List<String>.from(options);
    final correctText = opts[correctIndex];
    opts.shuffle(rng);
    return QuizQuestion(
      id: id,
      prompt: prompt,
      options: opts,
      correctIndex: opts.indexOf(correctText),
    );
  }

  /// Author with correct answer first (stable catalog typing).
  factory QuizQuestion.correctFirst(
    String id,
    String prompt,
    String correct,
    List<String> wrongThree,
  ) {
    assert(wrongThree.length == 3);
    return QuizQuestion(
      id: id,
      prompt: prompt,
      options: [correct, wrongThree[0], wrongThree[1], wrongThree[2]],
      correctIndex: 0,
    );
  }
}

/// In-memory run state (MVP — not persisted).
class QuizSession {
  QuizSession({
    required this.topic,
    required this.questions,
  }) : assert(questions.length == QuizScoring.questionsPerRun);

  final QuizTopic topic;
  final List<QuizQuestion> questions;

  int currentIndex = 0;
  int score = 0;
  int correctCount = 0;

  /// Sum of time spent per question until answer or timeout.
  Duration totalAnswerTime = Duration.zero;

  bool get isComplete => currentIndex >= questions.length;

  QuizQuestion get currentQuestion => questions[currentIndex];

  void recordAnswer({
    required bool correct,
    required Duration questionElapsed,
  }) {
    totalAnswerTime += questionElapsed;
    if (correct) {
      correctCount++;
      score += QuizScoring.pointsPerCorrect;
    } else {
      score += QuizScoring.pointsWrongOrTimeout;
    }
    currentIndex++;
  }

  bool get passed => score >= QuizScoring.minimumScoreToPass;

  bool get qualifiesFast =>
      totalAnswerTime <= QuizScoring.fastSessionThreshold;
}
