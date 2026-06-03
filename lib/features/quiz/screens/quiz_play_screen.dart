import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_question.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_result_screen.dart';
import 'package:catlab_quiz/features/quiz/widgets/answer_button.dart';
import 'package:catlab_quiz/features/quiz/widgets/quiz_progress_bar.dart';
import 'package:catlab_quiz/l10n/app_localizations.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class QuizPlayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String categoryKey;
  final String quizTitle;

  const QuizPlayScreen({
    super.key,
    required this.questions,
    required this.categoryKey,
    required this.quizTitle,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;

  QuizQuestion get _currentQuestion => widget.questions[_currentIndex];
  bool get _answered => _selectedIndex != null;

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      if (index == _currentQuestion.correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    final isLast = _currentIndex == widget.questions.length - 1;
    if (isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => QuizResultScreen(
            score: _score,
            total: widget.questions.length,
            categoryKey: widget.categoryKey,
            quizTitle: widget.quizTitle,
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
    }
  }

  AnswerState _stateFor(int index) {
    if (!_answered) return AnswerState.none;
    if (index == _currentQuestion.correctIndex) return AnswerState.correct;
    if (index == _selectedIndex) return AnswerState.wrong;
    return AnswerState.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppTheme.textDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            MediaQuery.of(context).viewPadding.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuizProgressBar(
                current: _currentIndex + 1,
                total: widget.questions.length,
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    _currentQuestion.question,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                _currentQuestion.answers.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnswerButton(
                    text: _currentQuestion.answers[i],
                    state: _stateFor(i),
                    onTap: _answered ? null : () => _selectAnswer(i),
                  ),
                ),
              ),
              if (_answered) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withAlpha(80)),
                  ),
                  child: Text(
                    _currentQuestion.explanation,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _currentIndex == widget.questions.length - 1
                        ? AppLocalizations.of(context)!.showResult
                        : AppLocalizations.of(context)!.next,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
