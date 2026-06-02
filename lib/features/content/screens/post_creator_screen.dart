import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/data/post_image_export_service.dart';
import 'package:catlab_quiz/features/content/widgets/post_preview_card.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_question.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class PostCreatorScreen extends StatefulWidget {
  const PostCreatorScreen({super.key});

  @override
  State<PostCreatorScreen> createState() => _PostCreatorScreenState();
}

class _PostCreatorScreenState extends State<PostCreatorScreen> {
  final _repo = QuizRepository();
  final _exportService = PostImageExportService();
  final _previewKey = GlobalKey();

  List<QuizDefinition> _catalog = [];
  QuizDefinition? _selectedQuiz;
  List<QuizQuestion> _questions = [];
  QuizQuestion? _selectedQuestion;
  bool _loadingCatalog = true;
  bool _loadingQuestions = false;
  bool _exportingPng = false;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    final catalog = await _repo.loadCatalog();
    if (mounted) {
      setState(() {
        _catalog = catalog;
        _loadingCatalog = false;
      });
    }
  }

  Future<void> _selectQuiz(QuizDefinition quiz) async {
    setState(() {
      _selectedQuiz = quiz;
      _selectedQuestion = null;
      _questions = [];
      _loadingQuestions = true;
    });
    final questions = await _repo.loadQuestions(quiz.assetPath);
    if (mounted) {
      setState(() {
        _questions = questions;
        _selectedQuestion = questions.isNotEmpty ? questions.first : null;
        _loadingQuestions = false;
      });
    }
  }

  // ── Post text ─────────────────────────────────────────────────────────────

  static const _labels = ['A', 'B', 'C', 'D'];

  // Prepared for v2: add PostFormat param to switch between questionPost / answerPost
  static String _buildPostText(QuizQuestion q) {
    final answers = List.generate(
      q.answers.length,
      (i) => '${_labels[i]}) ${q.answers[i]}',
    ).join('\n');
    return '🐱 Katzenfrage\n\n${q.question}\n\n$answers\n\nWas denkst du?\n\nMehr:\nquiz.schnurrpurr.com';
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _copyText(BuildContext context) async {
    final q = _selectedQuestion;
    if (q == null) return;
    await Clipboard.setData(ClipboardData(text: _buildPostText(q)));
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post-Text kopiert')));
    }
  }

  void _showShareSheet(BuildContext context) {
    final q = _selectedQuestion;
    if (q == null) return;
    final postText = _buildPostText(q);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => _ShareSheet(
        postText: postText,
        onCopy: () async {
          await Clipboard.setData(ClipboardData(text: postText));
          if (context.mounted) {
            Navigator.of(sheetCtx).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post-Text kopiert')),
            );
          }
        },
        // Prepared hooks — PNG export wired, scheduler/native share for v3
        onExportPng: () {
          Navigator.of(sheetCtx).pop();
          _exportPng(context);
        },
        onNativeShare: null,
        onExportToScheduler: null,
      ),
    );
  }

  Future<void> _exportPng(BuildContext context) async {
    final quiz = _selectedQuiz;
    final question = _selectedQuestion;
    if (quiz == null || question == null) return;

    // Capture before async gap
    final pixelRatio =
        MediaQuery.of(context).devicePixelRatio.clamp(2.0, 3.0);

    setState(() => _exportingPng = true);

    final bytes = await _exportService.renderToPng(
      _previewKey,
      pixelRatio: pixelRatio,
    );

    if (!context.mounted) return;
    setState(() => _exportingPng = false);

    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PNG-Erzeugung fehlgeschlagen')),
      );
      return;
    }

    final kb = (bytes.lengthInBytes / 1024).toStringAsFixed(1);
    final filename = _exportService.filenameFor(quiz.id, question.id);

    if (context.mounted) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('PNG wurde erzeugt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Größe', value: '$kb KB'),
              const SizedBox(height: 4),
              _InfoRow(label: 'Datei', value: filename),
              if (kIsWeb) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download, size: 15),
                    label: const Text('Herunterladen'),
                    onPressed: () {
                      _exportService.downloadOnWeb(filename, bytes);
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Schließen'),
            ),
          ],
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasSelection =
        _selectedQuiz != null && _selectedQuestion != null;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppTheme.textDark),
        title: const Text('Post Creator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 20),
      ),
      body: _loadingCatalog
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final actions = hasSelection
                    ? _ActionButtons(
                        onCopy: () => _copyText(context),
                        onShare: () => _showShareSheet(context),
                        onExportPng: () => _exportPng(context),
                        exportingPng: _exportingPng,
                      )
                    : null;

                if (constraints.maxWidth >= 600) {
                  return _WideLayout(
                    catalog: _catalog,
                    selectedQuiz: _selectedQuiz,
                    questions: _questions,
                    selectedQuestion: _selectedQuestion,
                    loadingQuestions: _loadingQuestions,
                    previewKey: _previewKey,
                    onQuizSelected: _selectQuiz,
                    onQuestionSelected: (q) =>
                        setState(() => _selectedQuestion = q),
                    actionButtons: actions,
                  );
                }
                return _NarrowLayout(
                  catalog: _catalog,
                  selectedQuiz: _selectedQuiz,
                  questions: _questions,
                  selectedQuestion: _selectedQuestion,
                  loadingQuestions: _loadingQuestions,
                  previewKey: _previewKey,
                  onQuizSelected: _selectQuiz,
                  onQuestionSelected: (q) =>
                      setState(() => _selectedQuestion = q),
                  actionButtons: actions,
                );
              },
            ),
    );
  }
}

// ── Info row (dialog helper) ──────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        Expanded(
          child: Text(value,
              style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        ),
      ],
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onExportPng;
  final bool exportingPng;

  const _ActionButtons({
    required this.onCopy,
    required this.onShare,
    required this.onExportPng,
    required this.exportingPng,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy, size: 15),
                  label: const Text('Text kopieren',
                      style: TextStyle(fontSize: 13)),
                  onPressed: onCopy,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share_outlined, size: 15),
                  label: const Text('Teilen vorbereiten',
                      style: TextStyle(fontSize: 13)),
                  onPressed: onShare,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: exportingPng
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.image_outlined, size: 15),
              label: Text(
                exportingPng ? 'Wird erstellt…' : 'PNG erstellen',
                style: const TextStyle(fontSize: 13),
              ),
              onPressed: exportingPng ? null : onExportPng,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Share sheet ───────────────────────────────────────────────────────────────

class _ShareSheet extends StatelessWidget {
  final String postText;
  final VoidCallback onCopy;
  final VoidCallback? onExportPng;
  final VoidCallback? onNativeShare;
  final VoidCallback? onExportToScheduler;

  const _ShareSheet({
    required this.postText,
    required this.onCopy,
    this.onExportPng,
    this.onNativeShare,
    this.onExportToScheduler,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teilen vorbereiten',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 180),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Text(postText,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.textDark)),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Text kopieren und in Facebook, Instagram, Threads oder Pinterest einfügen.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: const [
              _PlatformChip('📘 Facebook'),
              _PlatformChip('📷 Instagram'),
              _PlatformChip('🧵 Threads'),
              _PlatformChip('📌 Pinterest'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Abbrechen'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.copy, size: 15),
                  label: const Text('Text kopieren'),
                  onPressed: onCopy,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          if (onExportPng != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.image_outlined, size: 15),
                label: const Text('PNG erstellen'),
                onPressed: onExportPng,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final String label;
  const _PlatformChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ── Shared selector widgets ───────────────────────────────────────────────────

class _Selectors extends StatelessWidget {
  final List<QuizDefinition> catalog;
  final QuizDefinition? selectedQuiz;
  final List<QuizQuestion> questions;
  final QuizQuestion? selectedQuestion;
  final bool loadingQuestions;
  final void Function(QuizDefinition) onQuizSelected;
  final void Function(QuizQuestion) onQuestionSelected;

  const _Selectors({
    required this.catalog,
    required this.selectedQuiz,
    required this.questions,
    required this.selectedQuestion,
    required this.loadingQuestions,
    required this.onQuizSelected,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SelectorLabel('Quizbogen'),
        const SizedBox(height: 6),
        DropdownButtonFormField<QuizDefinition>(
          initialValue: selectedQuiz,
          decoration: _inputDeco('Quiz wählen...'),
          isExpanded: true,
          items: catalog
              .map(
                (q) => DropdownMenuItem(
                  value: q,
                  child: Text('${q.emoji} ${q.title}',
                      overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (q) {
            if (q != null) onQuizSelected(q);
          },
        ),
        const SizedBox(height: 16),
        _SelectorLabel('Frage'),
        const SizedBox(height: 6),
        if (loadingQuestions)
          const LinearProgressIndicator()
        else
          DropdownButtonFormField<QuizQuestion>(
            initialValue: selectedQuestion,
            decoration: _inputDeco(selectedQuiz == null
                ? 'Erst Quizbogen wählen'
                : 'Frage wählen...'),
            isExpanded: true,
            items: questions
                .map(
                  (q) => DropdownMenuItem(
                    value: q,
                    child: Text(
                      q.question.length > 55
                          ? '${q.question.substring(0, 55)}…'
                          : q.question,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (q) {
              if (q != null) onQuestionSelected(q);
            },
          ),
        const SizedBox(height: 20),
        _SelectorLabel('Format'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _FormatChip(label: '🐱 Frage-Post', active: true),
            _FormatChip(
                label: '✅ Auflösung', active: false, comingSoon: true),
          ],
        ),
      ],
    );
  }

  static InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      );
}

class _SelectorLabel extends StatelessWidget {
  final String text;
  const _SelectorLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark));
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  final bool active;
  final bool comingSoon;
  const _FormatChip(
      {required this.label, required this.active, this.comingSoon = false});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        comingSoon ? '$label (bald)' : label,
        style: TextStyle(
          fontSize: 11,
          color: active ? Colors.white : Colors.grey.shade400,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      backgroundColor: active ? AppTheme.primary : Colors.grey.shade100,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ── Preview placeholder ───────────────────────────────────────────────────────

class _PreviewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: Column(
        children: [
          const Text('🖼', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Quizbogen und Frage wählen\num die Vorschau zu sehen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ── Narrow layout (mobile) ────────────────────────────────────────────────────

class _NarrowLayout extends StatelessWidget {
  final List<QuizDefinition> catalog;
  final QuizDefinition? selectedQuiz;
  final List<QuizQuestion> questions;
  final QuizQuestion? selectedQuestion;
  final bool loadingQuestions;
  final GlobalKey previewKey;
  final void Function(QuizDefinition) onQuizSelected;
  final void Function(QuizQuestion) onQuestionSelected;
  final Widget? actionButtons;

  const _NarrowLayout({
    required this.catalog,
    required this.selectedQuiz,
    required this.questions,
    required this.selectedQuestion,
    required this.loadingQuestions,
    required this.previewKey,
    required this.onQuizSelected,
    required this.onQuestionSelected,
    required this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Selectors(
            catalog: catalog,
            selectedQuiz: selectedQuiz,
            questions: questions,
            selectedQuestion: selectedQuestion,
            loadingQuestions: loadingQuestions,
            onQuizSelected: onQuizSelected,
            onQuestionSelected: onQuestionSelected,
          ),
          const Divider(height: 32),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  if (selectedQuiz != null && selectedQuestion != null)
                    RepaintBoundary(
                      key: previewKey,
                      child: PostPreviewCard(
                        quiz: selectedQuiz!,
                        question: selectedQuestion!,
                      ),
                    )
                  else
                    _PreviewPlaceholder(),
                  if (actionButtons != null) actionButtons!,
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Wide layout (tablet / desktop) ───────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  final List<QuizDefinition> catalog;
  final QuizDefinition? selectedQuiz;
  final List<QuizQuestion> questions;
  final QuizQuestion? selectedQuestion;
  final bool loadingQuestions;
  final GlobalKey previewKey;
  final void Function(QuizDefinition) onQuizSelected;
  final void Function(QuizQuestion) onQuestionSelected;
  final Widget? actionButtons;

  const _WideLayout({
    required this.catalog,
    required this.selectedQuiz,
    required this.questions,
    required this.selectedQuestion,
    required this.loadingQuestions,
    required this.previewKey,
    required this.onQuizSelected,
    required this.onQuestionSelected,
    required this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 280,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SingleChildScrollView(
            child: _Selectors(
              catalog: catalog,
              selectedQuiz: selectedQuiz,
              questions: questions,
              selectedQuestion: selectedQuestion,
              loadingQuestions: loadingQuestions,
              onQuizSelected: onQuizSelected,
              onQuestionSelected: onQuestionSelected,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    if (selectedQuiz != null && selectedQuestion != null)
                      RepaintBoundary(
                        key: previewKey,
                        child: PostPreviewCard(
                          quiz: selectedQuiz!,
                          question: selectedQuestion!,
                        ),
                      )
                    else
                      _PreviewPlaceholder(),
                    if (actionButtons != null) actionButtons!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
