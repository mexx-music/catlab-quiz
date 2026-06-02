import 'package:flutter/material.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

enum AnswerState { none, correct, wrong }

class AnswerButton extends StatelessWidget {
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerButton({
    super.key,
    required this.text,
    this.state = AnswerState.none,
    this.onTap,
  });

  Color get _backgroundColor {
    return switch (state) {
      AnswerState.correct => AppTheme.correct,
      AnswerState.wrong => AppTheme.wrong,
      AnswerState.none => Colors.white,
    };
  }

  Color get _textColor {
    return switch (state) {
      AnswerState.correct || AnswerState.wrong => Colors.white,
      AnswerState.none => AppTheme.textDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.primary.withAlpha(100)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
      ),
    );
  }
}
