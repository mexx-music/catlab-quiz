// dart run tool/generate_content.dart
//
// Liest alle Quiz-JSON-Dateien aus assets/quiz/ und erzeugt pro Quiz
// eine _posts.json in assets/content/ mit je 10 Frage- und Auflösungs-Posts.

import 'dart:convert';
import 'dart:io';

void main() {
  const labels = ['A', 'B', 'C', 'D'];

  // Quiz-Titel aus dem Katalog laden
  final catalogRaw = File('assets/quiz/quiz_catalog.json').readAsStringSync();
  final catalog = json.decode(catalogRaw) as List<dynamic>;
  final titleMap = <String, String>{
    for (final e in catalog) e['id'] as String: e['title'] as String,
  };

  final contentDir = Directory('assets/content');
  if (!contentDir.existsSync()) contentDir.createSync(recursive: true);

  int totalPosts = 0;

  for (final entity in Directory('assets/quiz').listSync()
    ..sort((a, b) => a.path.compareTo(b.path))) {
    if (entity is! File) continue;
    final filename = entity.uri.pathSegments.last;
    if (filename == 'quiz_catalog.json') continue;
    if (!filename.endsWith('.json')) continue;

    final quizId = filename.replaceAll('.json', '');
    final title = titleMap[quizId] ?? quizId;
    final questions =
        json.decode(entity.readAsStringSync()) as List<dynamic>;

    final posts = <Map<String, String>>[];

    for (final raw in questions.take(10)) {
      final q = raw as Map<String, dynamic>;
      final questionText = q['question'] as String;
      final answers = (q['answers'] as List<dynamic>).cast<String>();
      final correctIndex = q['correctIndex'] as int;
      final explanation = q['explanation'] as String;
      final questionId = q['id'] as String;

      final answersBlock = List.generate(
        answers.length,
        (i) => '${labels[i]}) ${answers[i]}',
      ).join('\n');

      final questionPost =
          '🐱 Katzenfrage\n\n$questionText\n\n$answersBlock\n\nWas denkst du?\n\nMehr:\nquiz.schnurrpurr.com';

      final correctLetter = labels[correctIndex];
      final correctAnswer = answers[correctIndex];

      final answerPost =
          '✅ Auflösung – $title\n\nRichtige Antwort:\n$correctLetter) $correctAnswer\n\nErklärung:\n$explanation\n\n🐱 Mehr Katzenwissen:\nquiz.schnurrpurr.com';

      posts.add({
        'quizId': quizId,
        'questionId': questionId,
        'questionPost': questionPost,
        'answerPost': answerPost,
      });
    }

    final out = File('assets/content/${quizId}_posts.json');
    out.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(posts));
    totalPosts += posts.length;
    stdout.writeln('✓  ${out.path.padRight(55)} ${posts.length} Posts');
  }

  stdout.writeln('\nFertig – $totalPosts Posts in ${contentDir.path}/');
}
