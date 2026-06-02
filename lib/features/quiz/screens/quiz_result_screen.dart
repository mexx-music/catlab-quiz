import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/data/highscore_repository.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_home_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String categoryKey;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.categoryKey,
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

  String get _emoji {
    final ratio = widget.score / widget.total;
    if (ratio == 1.0) return '🏆';
    if (ratio >= 0.6) return '😺';
    return '🙀';
  }

  String get _message {
    final ratio = widget.score / widget.total;
    if (ratio == 1.0) return 'Perfekt! Du bist ein Katzen-Experte!';
    if (ratio >= 0.6) return 'Gut gemacht! Noch etwas üben!';
    return 'Weiter üben – du schaffst das!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                'Ergebnis',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${widget.score} / ${widget.total} Punkte',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _HighscoreInfo(
                previousHighscore: _previousHighscore,
                currentScore: widget.score,
                isNewHighscore: _isNewHighscore,
                total: widget.total,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const QuizHomeScreen(),
                    ),
                    (_) => false,
                  );
                },
                child: const Text('Nochmal spielen'),
              ),
            ],
          ),
        ),
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
            const Text(
              '🎉 Neuer Highscore!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            'Bestpunktzahl: ${isNewHighscore ? currentScore : (previousHighscore ?? currentScore)} / $total',
            style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
          ),
        ],
      ),
    );
  }
}
