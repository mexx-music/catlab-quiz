import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_home_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({super.key, required this.score, required this.total});

  String get _emoji {
    final ratio = score / total;
    if (ratio == 1.0) return '🏆';
    if (ratio >= 0.6) return '😺';
    return '🙀';
  }

  String get _message {
    final ratio = score / total;
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
                '$score / $total Punkte',
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
              const SizedBox(height: 48),
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
