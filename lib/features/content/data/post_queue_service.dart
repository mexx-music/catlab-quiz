import 'package:catlab_quiz/features/content/data/content_repository.dart';
import 'package:catlab_quiz/features/content/data/content_status_repository.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
import 'package:catlab_quiz/features/content/models/content_post_status.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';

class PostQueueService {
  final _quizRepo = QuizRepository();
  final _contentRepo = ContentRepository();
  final _statusRepo = ContentStatusRepository();

  List<ContentPost> _posts = [];
  Map<String, ContentPostStatus> _statusMap = {};
  Map<String, String> _titleMap = {};
  Map<String, String> _emojiMap = {};

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> load() async {
    final catalog = await _quizRepo.loadCatalog();
    _posts = await _contentRepo.loadAll(catalog);
    _statusMap = await _statusRepo.loadAll(_posts);
    _titleMap = {};
    _emojiMap = {};
    for (final quiz in catalog) {
      final id = _fileId(quiz);
      _titleMap[id] = quiz.title;
      _emojiMap[id] = quiz.emoji;
    }
  }

  // ── Queue queries ─────────────────────────────────────────────────────────

  /// First post where the question has not been posted yet.
  ContentPost? get nextQuestion {
    for (final p in _posts) {
      if (statusOf(p) == ContentPostStatus.notPosted) return p;
    }
    return null;
  }

  /// First post where the question was posted but the answer has not been yet.
  ContentPost? get nextAnswer {
    for (final p in _posts) {
      if (statusOf(p) == ContentPostStatus.questionPosted) return p;
    }
    return null;
  }

  // ── Statistics ────────────────────────────────────────────────────────────

  Map<ContentPostStatus, int> get statistics {
    final counts = {for (final s in ContentPostStatus.values) s: 0};
    for (final p in _posts) {
      final s = statusOf(p);
      counts[s] = (counts[s] ?? 0) + 1;
    }
    return counts;
  }

  bool get allDone =>
      _posts.isNotEmpty &&
      _posts.every((p) => statusOf(p) == ContentPostStatus.completed);

  // ── Mark actions ──────────────────────────────────────────────────────────

  Future<void> markQuestionPosted(ContentPost post) async {
    final newStatus = statusOf(post).markQuestion();
    await _statusRepo.setStatus(post.quizId, post.questionId, newStatus);
    _statusMap[_key(post)] = newStatus;
  }

  Future<void> markAnswerPosted(ContentPost post) async {
    final newStatus = statusOf(post).markAnswer();
    await _statusRepo.setStatus(post.quizId, post.questionId, newStatus);
    _statusMap[_key(post)] = newStatus;
  }

  // ── Display helpers ───────────────────────────────────────────────────────

  String titleOf(ContentPost post) => _titleMap[post.quizId] ?? post.quizId;

  String emojiOf(ContentPost post) => _emojiMap[post.quizId] ?? '🐱';

  ContentPostStatus statusOf(ContentPost post) =>
      _statusMap[_key(post)] ?? ContentPostStatus.notPosted;

  // ── Private ───────────────────────────────────────────────────────────────

  static String _key(ContentPost p) => '${p.quizId}_${p.questionId}';

  static String _fileId(QuizDefinition quiz) =>
      quiz.assetPath.split('/').last.replaceAll('.json', '');
}
