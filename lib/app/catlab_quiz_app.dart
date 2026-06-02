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
      builder: (context, child) {
        final w = MediaQuery.sizeOf(context).width;
        final maxWidth = w >= 1000 ? 900.0 : (w >= 600 ? 760.0 : double.infinity);
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child!,
          ),
        );
      },
      home: const QuizHomeScreen(),
    );
  }
}
