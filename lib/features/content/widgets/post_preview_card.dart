import 'package:flutter/material.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_question.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

// ── Format / Platform enums (v1: only questionPost implemented) ───────────────

enum PostFormat {
  questionPost, // ← implemented
  answerPost, //   prepared for v2
}

enum PostPlatform {
  instagram, // 1:1 or 4:5  — prepared for v2
  facebook, //  16:9         — prepared for v2
  pinterest, // 2:3          — prepared for v2
}

// ── Preview card ──────────────────────────────────────────────────────────────

class PostPreviewCard extends StatelessWidget {
  final QuizDefinition quiz;
  final QuizQuestion question;
  final PostFormat format;

  const PostPreviewCard({
    super.key,
    required this.quiz,
    required this.question,
    this.format = PostFormat.questionPost,
  });

  static const _labels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Banner(imageAsset: quiz.imageAsset, emoji: quiz.emoji),
          _Body(question: question),
          _Footer(quizId: quiz.id),
        ],
      ),
    );
  }
}

// ── Banner ────────────────────────────────────────────────────────────────────

class _Banner extends StatelessWidget {
  final String? imageAsset;
  final String emoji;
  const _Banner({required this.imageAsset, required this.emoji});

  @override
  Widget build(BuildContext context) {
    if (imageAsset != null) {
      return Image.asset(
        imageAsset!,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -0.5),
        errorBuilder: (_, __, ___) => _Placeholder(emoji: emoji),
      );
    }
    return _Placeholder(emoji: emoji);
  }
}

class _Placeholder extends StatelessWidget {
  final String emoji;
  const _Placeholder({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      color: AppTheme.secondary,
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 64)),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final QuizQuestion question;
  const _Body({required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🐱 Katzenfrage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Question text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Answer options
          ...List.generate(
            question.answers.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      PostPreviewCard._labels[i],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.answers[i],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textDark,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Was denkst du? 👇',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final String quizId;
  const _Footer({required this.quizId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(18),
        border: Border(
          top: BorderSide(color: AppTheme.primary.withAlpha(50)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teste dein Katzenwissen:',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.primary.withAlpha(180),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '🐱 quiz.schnurrpurr.com/?quiz=$quizId',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
