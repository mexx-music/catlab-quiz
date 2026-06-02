import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/quiz_definition.dart';
import '../models/quiz_question.dart';

const _allAssetPaths = [
  'assets/quiz/cat_breeds_beginner.json',
  'assets/quiz/cat_behavior.json',
  'assets/quiz/cat_purring.json',
  'assets/quiz/cat_myths.json',
];

class QuizRepository {
  Future<List<QuizDefinition>> loadCatalog() async {
    final jsonString = await rootBundle.loadString('assets/quiz/quiz_catalog.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => QuizDefinition.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<QuizQuestion>> loadQuestions(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    final questions = jsonList
        .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
    questions.shuffle(Random());
    return questions;
  }

  Future<List<QuizQuestion>> loadDailyQuestions({int count = 5}) async {
    final now = DateTime.now();
    final seed = int.parse(
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}',
    );
    final all = <QuizQuestion>[];
    for (final path in _allAssetPaths) {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      all.addAll(
        jsonList.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>)),
      );
    }
    all.shuffle(Random(seed));
    return all.take(count).toList();
  }
}
