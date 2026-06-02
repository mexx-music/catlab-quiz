import 'dart:convert';
import 'package:catlab_quiz/features/content/data/content_repository.dart';
import 'package:catlab_quiz/features/content/data/content_status_repository.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
import 'package:catlab_quiz/features/content/models/content_post_status.dart';
import 'package:catlab_quiz/features/quiz/data/quiz_repository.dart';

class ExportService {
  final _quizRepo = QuizRepository();
  final _contentRepo = ContentRepository();
  final _statusRepo = ContentStatusRepository();

  List<ContentPost> _posts = [];
  Map<String, ContentPostStatus> _statusMap = {};
  int _quizCount = 0;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> load() async {
    final catalog = await _quizRepo.loadCatalog();
    _quizCount = catalog.length;
    _posts = await _contentRepo.loadAll(catalog);
    _statusMap = await _statusRepo.loadAll(_posts);
  }

  // ── Statistics ────────────────────────────────────────────────────────────

  int get quizCount => _quizCount;
  int get totalPosts => _posts.length;
  int get openPosts =>
      _posts.where((p) => _statusOf(p) == ContentPostStatus.notPosted).length;
  int get completedPosts =>
      _posts.where((p) => _statusOf(p) == ContentPostStatus.completed).length;

  // ── JSON export ───────────────────────────────────────────────────────────

  String toJsonString() {
    final payload = {
      'generatedAt': DateTime.now().toIso8601String(),
      'stats': {
        'quizCount': _quizCount,
        'totalPosts': _posts.length,
        'open': openPosts,
        'completed': completedPosts,
      },
      'posts': _posts
          .map(
            (p) => {
              'postId': _postId(p),
              'quizId': p.quizId,
              'questionId': p.questionId,
              'type': 'quiz_pair',
              'status': _statusOf(p).name,
              'questionPost': p.questionPost,
              'answerPost': p.answerPost,
            },
          )
          .toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  // ── CSV export ────────────────────────────────────────────────────────────

  // Columns: postId, quizId, questionId, type, status, questionPost, answerPost
  String toCsvString() {
    final sb = StringBuffer();
    sb.writeln(
        'postId,quizId,questionId,type,status,questionPost,answerPost');
    for (final p in _posts) {
      sb.writeln([
        _csv(_postId(p)),
        _csv(p.quizId),
        _csv(p.questionId),
        _csv('quiz_pair'),
        _csv(_statusOf(p).name),
        _csv(p.questionPost),
        _csv(p.answerPost),
      ].join(','));
    }
    return sb.toString();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  ContentPostStatus _statusOf(ContentPost p) =>
      _statusMap['${p.quizId}_${p.questionId}'] ?? ContentPostStatus.notPosted;

  static String _postId(ContentPost p) => '${p.quizId}_${p.questionId}';

  // RFC 4180 CSV: wrap every field in quotes, escape internal quotes by doubling
  static String _csv(String value) =>
      '"${value.replaceAll('"', '""')}"';

}
