import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/data/content_repository.dart';
import 'package:catlab_quiz/features/content/data/content_status_repository.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
import 'package:catlab_quiz/features/content/models/content_post_status.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class ContentLibraryScreen extends StatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  State<ContentLibraryScreen> createState() => _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends State<ContentLibraryScreen> {
  final _quizRepo = QuizRepository();
  final _contentRepo = ContentRepository();
  final _statusRepo = ContentStatusRepository();

  List<ContentPost> _posts = [];
  Map<String, String> _titleMap = {};
  Map<String, String> _emojiMap = {};
  List<String> _quizIds = [];
  Map<String, ContentPostStatus> _statusMap = {};

  String? _quizFilter;
  ContentPostStatus? _statusFilter;
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

    final seen = <String>{};
    final ids = posts.map((p) => p.quizId).where(seen.add).toList();

    if (mounted) {
      setState(() {
        _posts = posts;
        _titleMap = tMap;
        _emojiMap = eMap;
        _quizIds = ids;
        _statusMap = statusMap;
        _loading = false;
      });
    }
  }

  static String _fileId(QuizDefinition quiz) =>
      quiz.assetPath.split('/').last.replaceAll('.json', '');

  static String _mapKey(ContentPost p) => '${p.quizId}_${p.questionId}';

  ContentPostStatus _statusOf(ContentPost p) =>
      _statusMap[_mapKey(p)] ?? ContentPostStatus.notPosted;

  Future<void> _setStatus(ContentPost post, ContentPostStatus status) async {
    await _statusRepo.setStatus(post.quizId, post.questionId, status);
    if (mounted) {
      setState(() => _statusMap[_mapKey(post)] = status);
    }
  }

  List<ContentPost> get _filtered {
    var list = _posts;
    if (_quizFilter != null) {
      list = list.where((p) => p.quizId == _quizFilter).toList();
    }
    if (_statusFilter != null) {
      list = list.where((p) => _statusOf(p) == _statusFilter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppTheme.textDark),
        title: const Text('Content Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 20),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Status filter
                _ChipRow(
                  chips: [
                    _ChipData(
                        label: 'Alle',
                        selected: _statusFilter == null,
                        onTap: () =>
                            setState(() => _statusFilter = null)),
                    ...ContentPostStatus.values.map(
                      (s) => _ChipData(
                        label: s.label,
                        selected: _statusFilter == s,
                        onTap: () => setState(() => _statusFilter = s),
                        color: s.badgeColor,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                // Quiz filter
                _ChipRow(
                  chips: [
                    _ChipData(
                        label: 'Alle Quizbögen',
                        selected: _quizFilter == null,
                        onTap: () =>
                            setState(() => _quizFilter = null)),
                    ..._quizIds.map(
                      (qid) => _ChipData(
                        label:
                            '${_emojiMap[qid] ?? ''} ${_titleMap[qid] ?? qid}',
                        selected: _quizFilter == qid,
                        onTap: () => setState(() => _quizFilter = qid),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(
                          child: Text('Keine Posts in dieser Auswahl.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) {
                            final post = _filtered[i];
                            final status = _statusOf(post);
                            return _PostCard(
                              post: post,
                              title:
                                  _titleMap[post.quizId] ?? post.quizId,
                              emoji: _emojiMap[post.quizId] ?? '🐱',
                              status: status,
                              onMarkQuestion: () => _setStatus(
                                  post, status.markQuestion()),
                              onMarkAnswer: () =>
                                  _setStatus(post, status.markAnswer()),
                              onReset: () => _setStatus(
                                  post, ContentPostStatus.notPosted),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ── Chip row ──────────────────────────────────────────────────────────────────

class _ChipData {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _ChipData({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });
}

class _ChipRow extends StatelessWidget {
  final List<_ChipData> chips;
  const _ChipRow({required this.chips});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: chips
            .map((c) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c.label,
                        style: const TextStyle(fontSize: 12)),
                    selected: c.selected,
                    onSelected: (_) => c.onTap(),
                    selectedColor: c.color ?? AppTheme.primary,
                    labelStyle: TextStyle(
                      color: c.selected ? Colors.white : AppTheme.textDark,
                      fontWeight: c.selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── Post card ─────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final ContentPost post;
  final String title;
  final String emoji;
  final ContentPostStatus status;
  final VoidCallback onMarkQuestion;
  final VoidCallback onMarkAnswer;
  final VoidCallback onReset;

  const _PostCard({
    required this.post,
    required this.title,
    required this.emoji,
    required this.status,
    required this.onMarkQuestion,
    required this.onMarkAnswer,
    required this.onReset,
  });

  Future<void> _copy(BuildContext context, String text, String msg) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                Text(
                  post.questionId,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade400),
                ),
                const SizedBox(width: 8),
                _StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 12),

            // Question post block
            _PostBlock(
              label: 'Frage-Post',
              text: post.questionPost,
              buttonLabel: 'Kopieren',
              onCopy: () => _copy(
                  context, post.questionPost, 'Frage-Post kopiert'),
            ),
            const SizedBox(height: 10),

            // Answer post block
            _PostBlock(
              label: 'Auflösungs-Post',
              text: post.answerPost,
              buttonLabel: 'Auflösung kopieren',
              onCopy: () => _copy(
                  context, post.answerPost, 'Auflösung kopiert'),
            ),
            const SizedBox(height: 12),

            // Status action buttons
            _StatusActions(
              status: status,
              onMarkQuestion: onMarkQuestion,
              onMarkAnswer: onMarkAnswer,
              onReset: onReset,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final ContentPostStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.badgeColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.badgeColor.withAlpha(120)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: status.badgeColor,
        ),
      ),
    );
  }
}

// ── Status action buttons ─────────────────────────────────────────────────────

class _StatusActions extends StatelessWidget {
  final ContentPostStatus status;
  final VoidCallback onMarkQuestion;
  final VoidCallback onMarkAnswer;
  final VoidCallback onReset;

  const _StatusActions({
    required this.status,
    required this.onMarkQuestion,
    required this.onMarkAnswer,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final showMarkQuestion = status == ContentPostStatus.notPosted ||
        status == ContentPostStatus.answerPosted;
    final showMarkAnswer = status == ContentPostStatus.notPosted ||
        status == ContentPostStatus.questionPosted;
    final showReset = status != ContentPostStatus.notPosted;

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        if (showMarkQuestion)
          _ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Frage markieren',
            color: Colors.orange,
            onTap: onMarkQuestion,
          ),
        if (showMarkAnswer)
          _ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Auflösung markieren',
            color: Colors.blue,
            onTap: onMarkAnswer,
          ),
        if (showReset)
          _ActionButton(
            icon: Icons.refresh,
            label: 'Zurücksetzen',
            color: Colors.grey.shade500,
            onTap: onReset,
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, color: color)),
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        side: BorderSide(color: color.withAlpha(120)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ── Post block ────────────────────────────────────────────────────────────────

class _PostBlock extends StatelessWidget {
  final String label;
  final String text;
  final String buttonLabel;
  final VoidCallback onCopy;

  const _PostBlock({
    required this.label,
    required this.text,
    required this.buttonLabel,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style:
                const TextStyle(fontSize: 12, color: AppTheme.textDark),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.copy, size: 14),
            label: Text(buttonLabel,
                style: const TextStyle(fontSize: 13)),
            onPressed: onCopy,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primary,
              side: const BorderSide(color: AppTheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
