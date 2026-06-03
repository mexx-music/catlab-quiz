import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/quiz/data/highscore_repository.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_home_screen.dart';
import 'package:catlab_quiz/l10n/app_localizations.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class _Level {
  final String emoji;
  final String title;
  final String description;
  const _Level(this.emoji, this.title, this.description);
}

_Level _levelFor(int score, int total, AppLocalizations l10n) {
  final pct = total > 0 ? score / total : 0.0;
  if (pct >= 0.9) {
    return _Level('🏆', l10n.levelExpert, l10n.levelExpertDesc);
  }
  if (pct >= 0.7) {
    return _Level('😺', l10n.levelKnower, l10n.levelKnowerDesc);
  }
  if (pct >= 0.4) {
    return _Level('🐱', l10n.levelFriend, l10n.levelFriendDesc);
  }
  return _Level('🐾', l10n.levelBeginner, l10n.levelBeginnerDesc);
}

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String categoryKey;
  final String quizTitle;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.categoryKey,
    required this.quizTitle,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  final _highscoreRepo = HighscoreRepository();
  int? _previousHighscore;
  bool _isNewHighscore = false;

  @override
  void initState() {
    super.initState();
    _handleHighscore();
  }

  Future<void> _handleHighscore() async {
    final previous = await _highscoreRepo.getHighscore(widget.categoryKey);
    final isNew = await _highscoreRepo.saveIfHighscore(
      widget.categoryKey,
      widget.score,
    );
    if (mounted) {
      setState(() {
        _previousHighscore = previous;
        _isNewHighscore = isNew;
      });
    }
  }

  Future<void> _copyResult(BuildContext context, _Level level) async {
    final quizLink = widget.categoryKey == 'daily'
        ? 'quiz.schnurrpurr.com'
        : 'quiz.schnurrpurr.com/?quiz=${widget.categoryKey}';
    final text =
        '🐱 CatLab Quiz Ergebnis\n\nQuiz:\n${widget.quizTitle}\n\nPunkte:\n${widget.score}/${widget.total}\n\nStufe:\n${level.emoji} ${level.title}\n\nTeste dein Wissen:\n$quizLink';
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.resultCopied)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final level = _levelFor(widget.score, widget.total, l10n);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(level.emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                l10n.result,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.points(widget.score, widget.total),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              _LevelCard(level: level),
              const SizedBox(height: 16),
              _HighscoreInfo(
                previousHighscore: _previousHighscore,
                currentScore: widget.score,
                isNewHighscore: _isNewHighscore,
                total: widget.total,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: Text(l10n.copyResult),
                onPressed: () => _copyResult(context, level),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const QuizHomeScreen(),
                    ),
                    (_) => false,
                  );
                },
                child: Text(l10n.playAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final _Level level;
  const _LevelCard({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withAlpha(80)),
      ),
      child: Column(
        children: [
          Text(
            level.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            level.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _HighscoreInfo extends StatelessWidget {
  final int? previousHighscore;
  final int currentScore;
  final bool isNewHighscore;
  final int total;

  const _HighscoreInfo({
    required this.previousHighscore,
    required this.currentScore,
    required this.isNewHighscore,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNewHighscore ? AppTheme.primary : Colors.grey.shade200,
          width: isNewHighscore ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isNewHighscore) ...[
            Text(
              AppLocalizations.of(context)!.newHighscore,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            AppLocalizations.of(context)!.bestScore(
              isNewHighscore ? currentScore : (previousHighscore ?? currentScore),
              total,
            ),
            style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
          ),
        ],
      ),
    );
  }
}
