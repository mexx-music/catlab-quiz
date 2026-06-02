import 'package:flutter/material.dart';
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

  List<QuizDefinition> _catalog = [];
  QuizDefinition? _selectedQuiz;
  List<QuizQuestion> _questions = [];
  QuizQuestion? _selectedQuestion;
  bool _loadingCatalog = true;
  bool _loadingQuestions = false;

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

  @override
  Widget build(BuildContext context) {
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
                if (constraints.maxWidth >= 600) {
                  return _WideLayout(
                    catalog: _catalog,
                    selectedQuiz: _selectedQuiz,
                    questions: _questions,
                    selectedQuestion: _selectedQuestion,
                    loadingQuestions: _loadingQuestions,
                    onQuizSelected: _selectQuiz,
                    onQuestionSelected: (q) =>
                        setState(() => _selectedQuestion = q),
                  );
                }
                return _NarrowLayout(
                  catalog: _catalog,
                  selectedQuiz: _selectedQuiz,
                  questions: _questions,
                  selectedQuestion: _selectedQuestion,
                  loadingQuestions: _loadingQuestions,
                  onQuizSelected: _selectQuiz,
                  onQuestionSelected: (q) =>
                      setState(() => _selectedQuestion = q),
                );
              },
            ),
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
        // Quiz selector
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
                  child: Text(
                    '${q.emoji} ${q.title}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (q) {
            if (q != null) onQuizSelected(q);
          },
        ),
        const SizedBox(height: 16),

        // Question selector
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

        // Format selector — v1 label only, prepared for v2
        _SelectorLabel('Format'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _FormatChip(label: '🐱 Frage-Post', active: true),
            _FormatChip(label: '✅ Auflösung', active: false, comingSoon: true),
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
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
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
      backgroundColor:
          active ? AppTheme.primary : Colors.grey.shade100,
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
          Text('🖼', style: const TextStyle(fontSize: 48)),
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
  final void Function(QuizDefinition) onQuizSelected;
  final void Function(QuizQuestion) onQuestionSelected;

  const _NarrowLayout({
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
              child: selectedQuiz != null && selectedQuestion != null
                  ? PostPreviewCard(
                      quiz: selectedQuiz!,
                      question: selectedQuestion!,
                    )
                  : _PreviewPlaceholder(),
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
  final void Function(QuizDefinition) onQuizSelected;
  final void Function(QuizQuestion) onQuestionSelected;

  const _WideLayout({
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel — selectors
        Container(
          width: 280,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey.shade200),
            ),
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
        // Right panel — preview
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: selectedQuiz != null && selectedQuestion != null
                    ? PostPreviewCard(
                        quiz: selectedQuiz!,
                        question: selectedQuestion!,
                      )
                    : _PreviewPlaceholder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
