import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/data/highscore_repository.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_play_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class _QuizCategory {
  final String title;
  final String emoji;
  final String assetPath;
  final String categoryKey;

  const _QuizCategory({
    required this.title,
    required this.emoji,
    required this.assetPath,
    required this.categoryKey,
  });
}

const _categories = [
  _QuizCategory(
    title: 'Katzenrassen',
    emoji: '🐈',
    assetPath: 'assets/quiz/cat_breeds_beginner.json',
    categoryKey: 'cat_breeds',
  ),
  _QuizCategory(
    title: 'Katzenverhalten',
    emoji: '🐾',
    assetPath: 'assets/quiz/cat_behavior.json',
    categoryKey: 'cat_behavior',
  ),
  _QuizCategory(
    title: 'Schnurren',
    emoji: '😸',
    assetPath: 'assets/quiz/cat_purring.json',
    categoryKey: 'cat_purring',
  ),
  _QuizCategory(
    title: 'Katzenmythen',
    emoji: '🔮',
    assetPath: 'assets/quiz/cat_myths.json',
    categoryKey: 'cat_myths',
  ),
];

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  final _highscoreRepo = HighscoreRepository();
  final Map<String, int?> _highscores = {};

  @override
  void initState() {
    super.initState();
    _loadHighscores();
  }

  Future<void> _loadHighscores() async {
    final results = <String, int?>{};
    for (final cat in _categories) {
      results[cat.categoryKey] = await _highscoreRepo.getHighscore(cat.categoryKey);
    }
    results['daily'] = await _highscoreRepo.getHighscore('daily');
    if (mounted) {
      setState(() => _highscores.addAll(results));
    }
  }

  Future<void> _startQuiz(BuildContext context, _QuizCategory category) async {
    final questions = await QuizRepository().loadQuestions(category.assetPath);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: category.categoryKey,
        ),
      ),
    );
    if (mounted) _loadHighscores();
  }

  Future<void> _startDailyQuiz(BuildContext context) async {
    final questions = await QuizRepository().loadDailyQuestions();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: 'daily',
        ),
      ),
    );
    if (mounted) _loadHighscores();
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
                'Wähle eine Kategorie:',
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
                      'Kategorien',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_categories.length, (index) {
                      final cat = _categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CategoryCard(
                          category: cat,
                          highscore: _highscores[cat.categoryKey],
                          onTap: () => _startQuiz(context, cat),
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

class _CategoryCard extends StatelessWidget {
  final _QuizCategory category;
  final int? highscore;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
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
              Text(category.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      highscore != null
                          ? 'Bestpunktzahl: $highscore / 5'
                          : 'Noch kein Highscore',
                      style: TextStyle(
                        fontSize: 12,
                        color: highscore != null
                            ? AppTheme.primary
                            : Colors.grey.shade500,
                      ),
                    ),
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
