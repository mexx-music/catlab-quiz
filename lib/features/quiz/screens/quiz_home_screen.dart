import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/data/highscore_repository.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_play_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  final _repo = QuizRepository();
  final _highscoreRepo = HighscoreRepository();
  List<QuizDefinition> _catalog = [];
  final Map<String, int?> _highscores = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final catalog = await _repo.loadCatalog();
    final results = <String, int?>{};
    results['daily'] = await _highscoreRepo.getHighscore('daily');
    for (final quiz in catalog) {
      results[quiz.id] = await _highscoreRepo.getHighscore(quiz.id);
    }
    if (mounted) {
      setState(() {
        _catalog = catalog;
        _highscores.addAll(results);
      });
    }
  }

  Future<void> _startQuiz(BuildContext context, QuizDefinition quiz) async {
    final questions = await _repo.loadQuestions(quiz.assetPath);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: quiz.id,
        ),
      ),
    );
    if (mounted) _loadData();
  }

  Future<void> _startDailyQuiz(BuildContext context) async {
    final questions = await _repo.loadDailyQuestions();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: 'daily',
        ),
      ),
    );
    if (mounted) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Text('🐱', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 8),
              Text(
                'CatLab Quiz',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                'Wähle einen Quizbogen:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _DailyQuizCard(
                      highscore: _highscores['daily'],
                      onTap: () => _startDailyQuiz(context),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Quizbögen',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_catalog.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      ...List.generate(_catalog.length, (index) {
                        final quiz = _catalog[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _QuizCard(
                            quiz: quiz,
                            highscore: _highscores[quiz.id],
                            onTap: () => _startQuiz(context, quiz),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyQuizCard extends StatelessWidget {
  final int? highscore;
  final VoidCallback onTap;

  const _DailyQuizCard({required this.highscore, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quiz des Tages',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      highscore != null
                          ? 'Bestpunktzahl: $highscore / 5'
                          : '5 zufällige Fragen aus allen Kategorien',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withAlpha(210),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final QuizDefinition quiz;
  final int? highscore;
  final VoidCallback onTap;

  const _QuizCard({
    required this.quiz,
    required this.highscore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Text(quiz.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quiz.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (highscore != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Bestpunktzahl: $highscore / 5',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
