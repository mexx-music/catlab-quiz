import 'package:shared_preferences/shared_preferences.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
import 'package:catlab_quiz/features/content/models/content_post_status.dart';

class ContentStatusRepository {
  static const String _prefix = 'content_status_';

  String _key(String quizId, String questionId) =>
      '$_prefix${quizId}_$questionId';

  Future<void> setStatus(
    String quizId,
    String questionId,
    ContentPostStatus status,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(quizId, questionId), status.name);
  }

  Future<Map<String, ContentPostStatus>> loadAll(
    List<ContentPost> posts,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, ContentPostStatus>{};
    for (final post in posts) {
      final mapKey = '${post.quizId}_${post.questionId}';
      final stored = prefs.getString(_key(post.quizId, post.questionId));
      if (stored != null) {
        map[mapKey] = ContentPostStatus.fromString(stored);
      }
    }
    return map;
  }
}
