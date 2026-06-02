import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_play_screen.dart';

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({super.key});

  Future<void> _startQuiz(BuildContext context) async {
    final questions = await QuizRepository().loadQuestions();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🐱', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                'CatLab Quiz',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Teste dein Wissen über Katzenrassen!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => _startQuiz(context),
                child: const Text('Quiz starten'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
