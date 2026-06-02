import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/data/content_repository.dart';
import 'package:catlab_quiz/features/content/data/content_status_repository.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
import 'package:catlab_quiz/features/content/models/content_post_status.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _quizRepo = QuizRepository();
  final _contentRepo = ContentRepository();
  final _statusRepo = ContentStatusRepository();

  List<ContentPost> _posts = [];
  Map<String, String> _titleMap = {};
  Map<String, String> _emojiMap = {};
  Map<String, ContentPostStatus> _statusMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final catalog = await _quizRepo.loadCatalog();
    final posts = await _contentRepo.loadAll(catalog);
    final statusMap = await _statusRepo.loadAll(posts);

    final tMap = <String, String>{};
    final eMap = <String, String>{};
    for (final quiz in catalog) {
      final qid = _fileId(quiz);
      tMap[qid] = quiz.title;
      eMap[qid] = quiz.emoji;
    }

    if (mounted) {
      setState(() {
        _posts = posts;
        _titleMap = tMap;
        _emojiMap = eMap;
        _statusMap = statusMap;
        _loading = false;
      });
    }
  }

  static String _fileId(QuizDefinition quiz) =>
      quiz.assetPath.split('/').last.replaceAll('.json', '');

  static String _key(ContentPost p) => '${p.quizId}_${p.questionId}';

  ContentPostStatus _statusOf(ContentPost p) =>
      _statusMap[_key(p)] ?? ContentPostStatus.notPosted;

  // First post where the question has not yet been posted
  ContentPost? get _nextQuestion {
    for (final p in _posts) {
      if (_statusOf(p) == ContentPostStatus.notPosted) return p;
    }
    return null;
  }

  // First post where the question was posted but the answer hasn't been yet
  ContentPost? get _nextAnswer {
    for (final p in _posts) {
      if (_statusOf(p) == ContentPostStatus.questionPosted) return p;
    }
    return null;
  }

  Map<ContentPostStatus, int> get _stats {
    final counts = {for (final s in ContentPostStatus.values) s: 0};
    for (final p in _posts) {
      final s = _statusOf(p);
      counts[s] = (counts[s] ?? 0) + 1;
    }
    return counts;
  }

  bool get _allDone =>
      _posts.isNotEmpty &&
      _posts.every((p) => _statusOf(p) == ContentPostStatus.completed);

  Future<void> _mark(ContentPost post, ContentPostStatus newStatus) async {
    await _statusRepo.setStatus(post.quizId, post.questionId, newStatus);
    if (mounted) setState(() => _statusMap[_key(post)] = newStatus);
  }

  Future<void> _copy(BuildContext context, String text, String msg) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppTheme.textDark),
        title: const Text('Heute posten'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 20),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsCard(stats: _stats),
                  const SizedBox(height: 20),
                  Text(
                    'Heute geplant:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  if (_allDone)
                    _AllDoneCard()
                  else ...[
                    _buildQuestionBlock(context),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    _buildAnswerBlock(context),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildQuestionBlock(BuildContext context) {
    final post = _nextQuestion;
    if (post == null) {
      return _EmptySlot(
        icon: '🐱',
        message: 'Keine offenen Fragen – alle wurden bereits gepostet.',
      );
    }
    final title = _titleMap[post.quizId] ?? post.quizId;
    final emoji = _emojiMap[post.quizId] ?? '🐱';
    return _TodayCard(
      sectionLabel: '🐱 Frage des Tages',
      quizLabel: '$emoji $title',
      postText: post.questionPost,
      onCopy: () => _copy(context, post.questionPost, 'Frage-Post kopiert'),
      actionLabel: 'Frage gepostet',
      actionColor: Colors.orange,
      onAction: () => _mark(post, ContentPostStatus.questionPosted),
    );
  }

  Widget _buildAnswerBlock(BuildContext context) {
    final post = _nextAnswer;
    if (post == null) {
      return _EmptySlot(
        icon: '✅',
        message: 'Keine Fragen warten auf ihre Auflösung.',
      );
    }
    final title = _titleMap[post.quizId] ?? post.quizId;
    final emoji = _emojiMap[post.quizId] ?? '🐱';
    return _TodayCard(
      sectionLabel: '✅ Auflösung',
      quizLabel: '$emoji $title',
      postText: post.answerPost,
      onCopy: () => _copy(context, post.answerPost, 'Auflösung kopiert'),
      actionLabel: 'Auflösung gepostet',
      actionColor: Colors.blue,
      onAction: () => _mark(post, ContentPostStatus.completed),
    );
  }
}

// ── Stats card ────────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final Map<ContentPostStatus, int> stats;
  const _StatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ContentPostStatus.values.map((s) {
          return Column(
            children: [
              Text(
                '${stats[s] ?? 0}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: s.badgeColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                s.label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Today card ────────────────────────────────────────────────────────────────

class _TodayCard extends StatelessWidget {
  final String sectionLabel;
  final String quizLabel;
  final String postText;
  final VoidCallback onCopy;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback onAction;

  const _TodayCard({
    required this.sectionLabel,
    required this.quizLabel,
    required this.postText,
    required this.onCopy,
    required this.actionLabel,
    required this.actionColor,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  sectionLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                Text(
                  quizLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Post text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              postText,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textDark,
                height: 1.5,
              ),
            ),
          ),
          // Action buttons
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy, size: 14),
                    label: const Text('Kopieren',
                        style: TextStyle(fontSize: 13)),
                    onPressed: onCopy,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.check_circle, size: 14,
                        color: Colors.white.withAlpha(220)),
                    label: Text(actionLabel,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white)),
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty slot ────────────────────────────────────────────────────────────────

class _EmptySlot extends StatelessWidget {
  final String icon;
  final String message;
  const _EmptySlot({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── All done ──────────────────────────────────────────────────────────────────

class _AllDoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: const Column(
        children: [
          Text('🎉', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            'Alle aktuellen Posts wurden verwendet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
