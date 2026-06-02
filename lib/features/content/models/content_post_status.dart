import 'package:flutter/material.dart';

enum ContentPostStatus {
  notPosted,
  questionPosted,
  answerPosted,
  completed;

  static ContentPostStatus fromString(String? value) =>
      ContentPostStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ContentPostStatus.notPosted,
      );

  String get label {
    switch (this) {
      case notPosted:
        return 'Offen';
      case questionPosted:
        return 'Frage gepostet';
      case answerPosted:
        return 'Auflösung gepostet';
      case completed:
        return 'Erledigt';
    }
  }

  Color get badgeColor {
    switch (this) {
      case notPosted:
        return Colors.grey.shade400;
      case questionPosted:
        return Colors.orange;
      case answerPosted:
        return Colors.blue;
      case completed:
        return Colors.green;
    }
  }

  ContentPostStatus markQuestion() =>
      this == answerPosted ? completed : questionPosted;

  ContentPostStatus markAnswer() =>
      this == questionPosted ? completed : answerPosted;
}
