class QuizDefinition {
  final String id;
  final String title;
  final String description;
  final String category;
  final String emoji;
  final String assetPath;
  final String socialHeadline;
  final String socialTeaser;

  const QuizDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    required this.assetPath,
    required this.socialHeadline,
    required this.socialTeaser,
  });

  factory QuizDefinition.fromJson(Map<String, dynamic> json) {
    return QuizDefinition(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      emoji: json['emoji'] as String,
      assetPath: json['assetPath'] as String,
      socialHeadline: json['socialHeadline'] as String,
      socialTeaser: json['socialTeaser'] as String,
    );
  }
}
