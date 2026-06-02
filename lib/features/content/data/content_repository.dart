import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/models/content_post.dart';
import 'package:catlab_quiz/features/quiz/models/quiz_definition.dart';

class ContentRepository {
  // Derives the content file path from the quiz's assetPath filename.
  // e.g. assets/quiz/cat_breeds_beginner.json → assets/content/cat_breeds_beginner_posts.json
  static String contentPathFor(QuizDefinition quiz) {
    final filename = quiz.assetPath.split('/').last.replaceAll('.json', '');
    return 'assets/content/${filename}_posts.json';
  }

  Future<List<ContentPost>> loadAll(List<QuizDefinition> catalog) async {
    final all = <ContentPost>[];
    for (final quiz in catalog) {
      try {
        final jsonString =
            await rootBundle.loadString(contentPathFor(quiz));
        final list = json.decode(jsonString) as List<dynamic>;
        all.addAll(
          list.map((e) => ContentPost.fromJson(e as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip quiz if no content file exists yet
      }
    }
    return all;
  }
}
