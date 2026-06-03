import 'package:catlab_quiz/app/catlab_quiz_app.dart';
import 'package:catlab_quiz/app/locale_controller.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localeController.load();
  runApp(const CatlabQuizApp());
}
