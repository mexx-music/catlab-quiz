import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_play_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class _QuizCategory {
  final String title;
  final String emoji;
  final String assetPath;

  const _QuizCategory({
    required this.title,
    required this.emoji,
    required this.assetPath,
  });
}

const _categories = [
  _QuizCategory(
    title: 'Katzenrassen',
    emoji: '🐈',
    assetPath: 'assets/quiz/cat_breeds_beginner.json',
  ),
  _QuizCategory(
    title: 'Katzenverhalten',
    emoji: '🐾',
    assetPath: 'assets/quiz/cat_behavior.json',
  ),
  _QuizCategory(
    title: 'Schnurren',
    emoji: '😸',
    assetPath: 'assets/quiz/cat_purring.json',
  ),
  _QuizCategory(
    title: 'Katzenmythen',
    emoji: '🔮',
    assetPath: 'assets/quiz/cat_myths.json',
  ),
];

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({super.key});

  Future<void> _startQuiz(BuildContext context, _QuizCategory category) async {
    final questions = await QuizRepository().loadQuestions(category.assetPath);
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(questions: questions),
      ),
    );
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
                child: ListView.separated(
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return _CategoryCard(
                      category: cat,
                      onTap: () => _startQuiz(context, cat),
                    );
                  },
                ),
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
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

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
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
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
