import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';

class QuizRepository {
  Future<List<QuizQuestion>> loadQuestions() async {
    final jsonString = await rootBundle.loadString(
      'assets/quiz/cat_breeds_beginner.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
