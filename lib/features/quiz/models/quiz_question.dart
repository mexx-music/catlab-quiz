import 'dart:math';

class QuizQuestion {
  final String id;
  final String category;
  final String difficulty;
  final String question;
  final List<String> answers;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
  });

  /// Returns a copy of this question with answers shuffled using [rng].
  /// The [correctIndex] is updated to reflect the new position of the
  /// correct answer. All other fields are unchanged.
  QuizQuestion withShuffledAnswers(Random rng) {
    final correctAnswer = answers[correctIndex];
    final shuffled = List<String>.from(answers)..shuffle(rng);
    return QuizQuestion(
      id: id,
      category: category,
      difficulty: difficulty,
      question: question,
      answers: shuffled,
      correctIndex: shuffled.indexOf(correctAnswer),
      explanation: explanation,
    );
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      question: json['question'] as String,
      answers: List<String>.from(json['answers'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
}
