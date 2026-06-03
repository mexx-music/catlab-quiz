import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_home_screen.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_play_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class CatlabQuizApp extends StatelessWidget {
  const CatlabQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatLab Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: (context, child) {
        final w = MediaQuery.sizeOf(context).width;
        final maxWidth =
            w >= 1000 ? 900.0 : (w >= 600 ? 760.0 : double.infinity);
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child!,
          ),
        );
      },
      home: const _AppStartup(),
    );
  }
}

// Reads the ?quiz= URL parameter on web and navigates directly to the matching
// quiz. Falls back to QuizHomeScreen when the parameter is absent or invalid.
class _AppStartup extends StatefulWidget {
  const _AppStartup();

  @override
  State<_AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<_AppStartup> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      final quizId = Uri.base.queryParameters['quiz'];
      if (quizId != null && quizId.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _launchDeepLink(quizId),
        );
      }
    }
  }

  Future<void> _launchDeepLink(String quizId) async {
    final repo = QuizRepository();
    final catalog = await repo.loadCatalog();
    final matches = catalog.where((q) => q.id == quizId);
    final quiz = matches.isEmpty ? null : matches.first;
    if (!mounted || quiz == null) return;
    final questions = await repo.loadQuestions(quiz.assetPath);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: quiz.id,
          quizTitle: quiz.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const QuizHomeScreen();
}
