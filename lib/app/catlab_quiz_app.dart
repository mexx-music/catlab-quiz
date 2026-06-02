import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_home_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class CatlabQuizApp extends StatelessWidget {
  const CatlabQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatLab Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: (context, child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: child!,
        ),
      ),
      home: const QuizHomeScreen(),
    );
  }
}
