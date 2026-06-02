import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/app/app_config.dart';
import 'package:catlab_quiz/features/quiz/data/highscore_repository.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/content/screens/content_library_screen.dart';
import 'package:catlab_quiz/features/content/screens/export_screen.dart';
import 'package:catlab_quiz/features/content/screens/post_creator_screen.dart';
import 'package:catlab_quiz/features/content/screens/today_screen.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_question.dart';
import 'package:catlab_quiz/features/quiz/screens/quiz_play_screen.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  final _repo = QuizRepository();
  final _highscoreRepo = HighscoreRepository();
  List<QuizDefinition> _catalog = [];
  final Map<String, int?> _highscores = {};
  QuizQuestion? _dailyQuestion;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final catalog = await _repo.loadCatalog();
    final dailyQ = await _repo.loadDailyQuestion();
    final results = <String, int?>{};
    results['daily'] = await _highscoreRepo.getHighscore('daily');
    for (final quiz in catalog) {
      results[quiz.id] = await _highscoreRepo.getHighscore(quiz.id);
    }
    if (mounted) {
      setState(() {
        _catalog = catalog;
        _dailyQuestion = dailyQ;
        _highscores.addAll(results);
      });
    }
  }

  Future<void> _startQuiz(BuildContext context, QuizDefinition quiz) async {
    final questions = await _repo.loadQuestions(quiz.assetPath);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: quiz.id,
          quizTitle: quiz.title,
        ),
      ),
    );
    if (mounted) _loadData();
  }

  Future<void> _startDailyQuiz(BuildContext context) async {
    final questions = await _repo.loadDailyQuestions();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          questions: questions,
          categoryKey: 'daily',
          quizTitle: 'Quiz des Tages',
        ),
      ),
    );
    if (mounted) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Text(
                'CatLab 🐱 Quiz',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                'Wähle einen Quizbogen:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (AppConfig.adminMode) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ToolButton(
                      icon: '📅',
                      label: 'Heute',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TodayScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _ToolButton(
                      icon: '📰',
                      label: 'Content',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ContentLibraryScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _ToolButton(
                      icon: '📤',
                      label: 'Export',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ExportScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _ToolButton(
                      icon: '🖼',
                      label: 'Creator',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PostCreatorScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
              Expanded(
                child: ListView(
                  children: [
                    _DailyQuizCard(
                      highscore: _highscores['daily'],
                      onTap: () => _startDailyQuiz(context),
                    ),
                    if (_dailyQuestion != null) ...[
                      const SizedBox(height: 12),
                      _DailyQuestionCard(
                        question: _dailyQuestion!,
                        onCopy: () async {
                          final q = _dailyQuestion!;
                          final labels = ['A', 'B', 'C', 'D'];
                          final answers = List.generate(
                            q.answers.length,
                            (i) => '${labels[i]}) ${q.answers[i]}',
                          ).join('\n');
                          final text =
                              '🐱 Frage des Tages:\n${q.question}\n\n$answers\n\nWas denkst du? Antwort später bei CatLab Quiz.';
                          await Clipboard.setData(ClipboardData(text: text));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Frage des Tages kopiert'),
                              ),
                            );
                          }
                        },
                        onCopyResolution: () async {
                          final q = _dailyQuestion!;
                          final labels = ['A', 'B', 'C', 'D'];
                          final letter = labels[q.correctIndex];
                          final text =
                              '✅ Auflösung zur Katzenfrage des Tages:\n\nRichtige Antwort:\n$letter) ${q.answers[q.correctIndex]}\n\nErklärung:\n${q.explanation}\n\n🐱 Mehr Katzenwissen bei CatLab Quiz.';
                          await Clipboard.setData(ClipboardData(text: text));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Auflösung kopiert'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      'Quizbögen',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_catalog.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cols = constraints.maxWidth >= 600 ? 2 : 1;
                          Widget card(quiz) => _QuizCard(
                                quiz: quiz,
                                highscore: _highscores[quiz.id],
                                onTap: () => _startQuiz(context, quiz),
                                onShowPost: () =>
                                    _showPostSheet(context, quiz),
                              );
                          if (cols == 1) {
                            return Column(
                              children: _catalog
                                  .map((q) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 12),
                                        child: card(q),
                                      ))
                                  .toList(),
                            );
                          }
                          final rows = <Widget>[];
                          for (var i = 0; i < _catalog.length; i += 2) {
                            final a = _catalog[i];
                            final b = i + 1 < _catalog.length
                                ? _catalog[i + 1]
                                : null;
                            rows.add(Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: card(a)),
                                  const SizedBox(width: 12),
                                  b != null
                                      ? Expanded(child: card(b))
                                      : const Expanded(child: SizedBox()),
                                ],
                              ),
                            ));
                          }
                          return Column(children: rows);
                        },
                      ),
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

void _showPostSheet(BuildContext context, QuizDefinition quiz) {
  final postText = '🐱 ${quiz.socialHeadline}\n${quiz.socialTeaser}';
  final hashtags = quiz.tags?.map((t) => '#$t').join(' ') ?? '';
  final seoText = [
    if (quiz.seoTitle != null) 'Titel: ${quiz.seoTitle}',
    if (quiz.seoDescription != null) 'Beschreibung: ${quiz.seoDescription}',
    if (hashtags.isNotEmpty) hashtags,
  ].join('\n');

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) => SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(sheetCtx).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quiz.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            postText,
            style: const TextStyle(fontSize: 15, color: AppTheme.textDark),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Kopieren'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: postText));
                if (context.mounted) {
                  Navigator.of(sheetCtx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post-Text kopiert')),
                  );
                }
              },
            ),
          ),
          if (seoText.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'SEO-Vorschlag:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            if (quiz.seoTitle != null) ...[
              const Text(
                'Titel:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark),
              ),
              Text(
                quiz.seoTitle!,
                style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
            ],
            if (quiz.seoDescription != null) ...[
              const Text(
                'Beschreibung:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark),
              ),
              Text(
                quiz.seoDescription!,
                style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
            ],
            if (hashtags.isNotEmpty) ...[
              const Text(
                'Tags:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark),
              ),
              Text(
                hashtags,
                style: const TextStyle(fontSize: 13, color: AppTheme.primary),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Kopieren (SEO)'),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: seoText));
                  if (context.mounted) {
                    Navigator.of(sheetCtx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SEO-Text kopiert')),
                    );
                  }
                },
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _QuizCard extends StatelessWidget {
  final QuizDefinition quiz;
  final int? highscore;
  final VoidCallback onTap;
  final VoidCallback onShowPost;

  const _QuizCard({
    required this.quiz,
    required this.highscore,
    required this.onTap,
    required this.onShowPost,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cw = constraints.maxWidth;
                  final h = cw >= 460 ? 200.0 : (cw >= 376 ? 170.0 : 150.0);
                  return quiz.imageAsset != null
                      ? Image.asset(
                          quiz.imageAsset!,
                          width: double.infinity,
                          height: h,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.5),
                          errorBuilder: (_, __, ___) =>
                              _ImagePlaceholder(quiz.emoji, height: h),
                        )
                      : _ImagePlaceholder(quiz.emoji, height: h);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Text(quiz.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          quiz.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (highscore != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Bestpunktzahl: $highscore / 5',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                        if (AppConfig.adminMode) ...[
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: onShowPost,
                            child: const Text(
                              'Post-Text anzeigen',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
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
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final String emoji;
  final double height;
  const _ImagePlaceholder(this.emoji, {this.height = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppTheme.secondary,
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 48)),
      ),
    );
  }
}

class _DailyQuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final VoidCallback onCopy;
  final VoidCallback onCopyResolution;

  const _DailyQuestionCard({
    required this.question,
    required this.onCopy,
    required this.onCopyResolution,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📅', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frage des Tages',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onCopy,
                        child: const Text(
                          'Post kopieren',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onCopyResolution,
                        child: Text(
                          'Auflösung kopieren',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Text(icon, style: const TextStyle(fontSize: 13)),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
    );
  }
}
