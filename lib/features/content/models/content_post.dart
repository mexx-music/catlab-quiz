class ContentPost {
  final String quizId;
  final String questionId;
  final String questionPost;
  final String answerPost;

  const ContentPost({
    required this.quizId,
    required this.questionId,
    required this.questionPost,
    required this.answerPost,
  });

  factory ContentPost.fromJson(Map<String, dynamic> json) {
    return ContentPost(
      quizId: json['quizId'] as String,
      questionId: json['questionId'] as String,
      questionPost: json['questionPost'] as String,
      answerPost: json['answerPost'] as String,
    );
  }
}
