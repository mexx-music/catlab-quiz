import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/data/post_queue_service.dart';
import 'package:catlab_quiz/features/content/models/content_post_status.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _queue = PostQueueService();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _queue.load();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _act(Future<void> Function() action) async {
    await action();
    if (mounted) setState(() {});
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
                  _StatsCard(stats: _queue.statistics),
                  const SizedBox(height: 20),
                  Text(
                    'Heute geplant:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  if (_queue.allDone)
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
    final post = _queue.nextQuestion;
    if (post == null) {
      return const _EmptySlot(
        icon: '🐱',
        message: 'Keine offenen Fragen – alle wurden bereits gepostet.',
      );
    }
    return _TodayCard(
      sectionLabel: '🐱 Frage des Tages',
      quizLabel: '${_queue.emojiOf(post)} ${_queue.titleOf(post)}',
      postText: post.questionPost,
      onCopy: () => _copy(context, post.questionPost, 'Frage-Post kopiert'),
      actionLabel: 'Frage gepostet',
      actionColor: Colors.orange,
      onAction: () => _act(() => _queue.markQuestionPosted(post)),
    );
  }

  Widget _buildAnswerBlock(BuildContext context) {
    final post = _queue.nextAnswer;
    if (post == null) {
      return const _EmptySlot(
        icon: '✅',
        message: 'Keine Fragen warten auf ihre Auflösung.',
      );
    }
    return _TodayCard(
      sectionLabel: '✅ Auflösung',
      quizLabel: '${_queue.emojiOf(post)} ${_queue.titleOf(post)}',
      postText: post.answerPost,
      onCopy: () => _copy(context, post.answerPost, 'Auflösung kopiert'),
      actionLabel: 'Auflösung gepostet',
      actionColor: Colors.blue,
      onAction: () => _act(() => _queue.markAnswerPosted(post)),
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
