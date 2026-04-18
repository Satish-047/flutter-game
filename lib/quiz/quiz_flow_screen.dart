import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/clay_shadows.dart';
import '../theme/gummy_layout.dart';
import '../widgets/session_results_body.dart';
import 'quiz_catalog.dart';
import 'quiz_models.dart';
import 'quiz_scoring.dart';

/// Root route for Quiz mode — topic pick (random) → timed questions → results.
/// No bottom navigation; shell tab bar remains under this route until popped.
class QuizFlowScreen extends StatefulWidget {
  const QuizFlowScreen({super.key});

  @override
  State<QuizFlowScreen> createState() => _QuizFlowScreenState();
}

enum _Phase { intro, question, results }

class _QuizFlowScreenState extends State<QuizFlowScreen>
    with TickerProviderStateMixin {
  _Phase _phase = _Phase.intro;
  QuizSession? _session;
  AnimationController? _timerController;
  DateTime? _questionStartedAt;
  bool _answerLocked = false;

  @override
  void dispose() {
    _timerController?.dispose();
    super.dispose();
  }

  void _timerTick() {
    if (mounted) setState(() {});
  }

  void _disposeTimer() {
    _timerController?.removeStatusListener(_onTimerStatus);
    _timerController?.removeListener(_timerTick);
    _timerController?.dispose();
    _timerController = null;
  }

  void _prepareSession(QuizTopic topic, List<QuizQuestion> round) {
    _disposeTimer();
    _session = QuizSession(topic: topic, questions: round);
    _answerLocked = false;
  }

  /// New random topic, shuffled question order and shuffled options per question.
  void _startNewRun() {
    final rng = Random();
    final topic = kQuizTopicBank[rng.nextInt(kQuizTopicBank.length)];
    final round = topic.questions.map((q) => q.shuffled(rng)).toList()
      ..shuffle(rng);
    _prepareSession(topic, round);
  }

  @override
  void initState() {
    super.initState();
    _startNewRun();
  }

  Future<void> _maybePopQuiz() async {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<bool> _confirmDiscard() async {
    final scheme = Theme.of(context).colorScheme;
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave quiz?'),
        content: const Text(
          'Your progress in this round will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Leave'),
          ),
        ],
        backgroundColor: scheme.surfaceContainerLowest,
      ),
    );
    return r ?? false;
  }

  void _onStartTapped() {
    setState(() => _phase = _Phase.question);
    _beginCurrentQuestion();
  }

  void _beginCurrentQuestion() {
    final session = _session;
    if (session == null || session.isComplete) return;

    _disposeTimer();
    _answerLocked = false;
    _questionStartedAt = DateTime.now();

    final c = AnimationController(
      vsync: this,
      duration: QuizScoring.perQuestionLimit,
    );
    _timerController = c;
    c.addStatusListener(_onTimerStatus);
    c.addListener(_timerTick);
    c.forward();
    setState(() {});
  }

  void _onTimerStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    _onQuestionTimeout();
  }

  void _onQuestionTimeout() {
    if (_answerLocked || _session == null) return;
    _answerLocked = true;
    _timerController?.stop();

    final elapsed = QuizScoring.perQuestionLimit;
    _session!.recordAnswer(correct: false, questionElapsed: elapsed);
    _afterQuestion();
  }

  void _onChooseAnswer(int optionIndex) {
    if (_answerLocked || _session == null) return;
    _answerLocked = true;
    _timerController?.stop();

    final session = _session!;
    final q = session.currentQuestion;
    final correct = optionIndex == q.correctIndex;
    final elapsed = DateTime.now().difference(_questionStartedAt!);

    session.recordAnswer(correct: correct, questionElapsed: elapsed);
    _afterQuestion();
  }

  void _afterQuestion() {
    if (!mounted) return;
    final session = _session!;
    if (session.isComplete) {
      _disposeTimer();
      setState(() => _phase = _Phase.results);
      return;
    }
    setState(() {});
    _beginCurrentQuestion();
  }

  void _playAgain() {
    _startNewRun();
    setState(() => _phase = _Phase.intro);
  }

  Future<void> _handlePopInvoked(bool didPop, dynamic result) async {
    if (didPop) return;
    if (_phase != _Phase.question) return;
    final leave = await _confirmDiscard();
    if (leave && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _session!;
    final scheme = Theme.of(context).colorScheme;

    String title;
    switch (_phase) {
      case _Phase.intro:
        title = 'Quiz';
      case _Phase.question:
        title = 'Question ${session.currentIndex + 1}/${QuizScoring.questionsPerRun}';
      case _Phase.results:
        title = 'Final Score';
    }

    final canPopDirect = _phase != _Phase.question;

    return PopScope(
      canPop: canPopDirect,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (_phase == _Phase.question) {
                final leave = await _confirmDiscard();
                if (leave && mounted) await _maybePopQuiz();
              } else {
                await _maybePopQuiz();
              }
            },
          ),
          title: Text(title),
          actions: [
            if (_phase == _Phase.question)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Score: ${session.score}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                  ),
                ),
              ),
            if (_phase == _Phase.results)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Score: ${session.score}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                  ),
                ),
              ),
          ],
        ),
        body: switch (_phase) {
          _Phase.intro => _QuizIntroBody(
              topic: session.topic,
              onStart: _onStartTapped,
            ),
          _Phase.question => _QuizQuestionBody(
              session: session,
              timerController: _timerController,
              onChoose: _onChooseAnswer,
              locked: _answerLocked,
            ),
          _Phase.results => _QuizResultsPanel(
              session: session,
              onPlayAgain: _playAgain,
            ),
        },
      ),
    );
  }
}

class _QuizResultsPanel extends StatelessWidget {
  const _QuizResultsPanel({
    required this.session,
    required this.onPlayAgain,
  });

  final QuizSession session;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final passed = session.passed;
    final chipLabel = session.qualifiesFast ? 'Fast' : 'Steady';

    return SessionResultsBody(
      score: session.score,
      passed: passed,
      bannerPass: 'YOU WIN!',
      bannerFail: 'KEEP TRYING!',
      chips: [
        ResultStatChipData(
          icon: Icons.timer_outlined,
          label: formatSessionDuration(session.totalAnswerTime),
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          iconColor: scheme.secondary,
        ),
        ResultStatChipData(
          icon: Icons.check_circle_outline_rounded,
          label:
              '${session.correctCount}/${QuizScoring.questionsPerRun}',
          background: scheme.tertiaryContainer,
          foreground: scheme.onTertiaryContainer,
          iconColor: scheme.tertiary,
        ),
        ResultStatChipData(
          icon: Icons.rocket_launch_rounded,
          label: chipLabel,
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          iconColor: scheme.primary,
        ),
      ],
      onPrimary: onPlayAgain,
      primaryLabel: 'Play Again',
    );
  }
}

// --- Intro ---

class _QuizIntroBody extends StatelessWidget {
  const _QuizIntroBody({
    required this.topic,
    required this.onStart,
  });

  final QuizTopic topic;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        GummyLayout.pagePaddingH,
        GummyLayout.sectionGap,
        GummyLayout.pagePaddingH,
        32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your topic today',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${topic.emoji} ${topic.title}',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
          if (topic.description != null) ...[
            const SizedBox(height: 12),
            Text(
              topic.description!,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
              boxShadow: ClayShadows.ambient(scheme.shadow, y: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_rounded, color: scheme.secondary, size: 28),
                const SizedBox(width: 12),
                Text(
                  '${QuizScoring.questionsPerRun} questions · timed',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
              ),
            ),
            child: Text(
              'Start',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Question ---

class _QuizQuestionBody extends StatelessWidget {
  const _QuizQuestionBody({
    required this.session,
    required this.timerController,
    required this.onChoose,
    required this.locked,
  });

  final QuizSession session;
  final AnimationController? timerController;
  final void Function(int index) onChoose;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final q = session.currentQuestion;
    final c = timerController;

    final progress = c == null ? 1.0 : 1.0 - c.value;
    final totalSec = QuizScoring.perQuestionLimit.inSeconds;
    final left = c == null
        ? totalSec
        : (totalSec * (1.0 - c.value)).ceil().clamp(0, totalSec);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        GummyLayout.pagePaddingH,
        GummyLayout.blockGap,
        GummyLayout.pagePaddingH,
        32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: scheme.surfaceContainerHigh,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time left',
                style: textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${left}s',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
              boxShadow: ClayShadows.ambient(scheme.shadow, y: 10),
            ),
            child: Text(
              q.prompt,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: scheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < q.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: scheme.secondaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(GummyLayout.clayRadiusMd),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: locked ? null : () => onChoose(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: scheme.onSecondaryContainer.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
