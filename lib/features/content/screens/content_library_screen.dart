import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/data/content_repository.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
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

  List<ContentPost> _posts = [];
  Map<String, String> _titleMap = {};
  Map<String, String> _emojiMap = {};
  List<String> _quizIds = [];
  String? _filter;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final catalog = await _quizRepo.loadCatalog();
    final posts = await _contentRepo.loadAll(catalog);

    final tMap = <String, String>{};
    final eMap = <String, String>{};
    for (final quiz in catalog) {
      final qid = _quizIdFrom(quiz);
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
        _loading = false;
      });
    }
  }

  static String _quizIdFrom(QuizDefinition quiz) =>
      quiz.assetPath.split('/').last.replaceAll('.json', '');

  List<ContentPost> get _filtered => _filter == null
      ? _posts
      : _posts.where((p) => p.quizId == _filter).toList();

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
                _FilterRow(
                  quizIds: _quizIds,
                  titleMap: _titleMap,
                  emojiMap: _emojiMap,
                  selected: _filter,
                  onSelect: (id) => setState(() => _filter = id),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(child: Text('Keine Posts vorhanden.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) {
                            final post = _filtered[i];
                            return _PostCard(
                              post: post,
                              title: _titleMap[post.quizId] ?? post.quizId,
                              emoji: _emojiMap[post.quizId] ?? '🐱',
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final List<String> quizIds;
  final Map<String, String> titleMap;
  final Map<String, String> emojiMap;
  final String? selected;
  final void Function(String? id) onSelect;

  const _FilterRow({
    required this.quizIds,
    required this.titleMap,
    required this.emojiMap,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          _Chip(
            label: 'Alle',
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
          ...quizIds.map(
            (qid) => _Chip(
              label: '${emojiMap[qid] ?? ''} ${titleMap[qid] ?? qid}',
              selected: selected == qid,
              onTap: () => onSelect(qid),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.textDark,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// ── Post card ─────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final ContentPost post;
  final String title;
  final String emoji;

  const _PostCard({
    required this.post,
    required this.title,
    required this.emoji,
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
            // Header
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
              ],
            ),
            const SizedBox(height: 12),
            _PostBlock(
              label: 'Frage-Post',
              text: post.questionPost,
              buttonLabel: 'Kopieren',
              onCopy: () =>
                  _copy(context, post.questionPost, 'Frage-Post kopiert'),
            ),
            const SizedBox(height: 10),
            _PostBlock(
              label: 'Auflösungs-Post',
              text: post.answerPost,
              buttonLabel: 'Auflösung kopieren',
              onCopy: () =>
                  _copy(context, post.answerPost, 'Auflösung kopiert'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Post block (label + text box + copy button) ───────────────────────────────

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
            style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
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
