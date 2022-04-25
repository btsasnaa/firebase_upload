import 'package:firebase_upload/models/my_answer_option.dart';

class QuizMessage {
  final String id;
  final String? text;
  final String type;
  final String subType;
  final Question? question;

  QuizMessage({
    required this.id,
    this.text,
    required this.type,
    required this.subType,
    this.question,
  });
}

class Question {
  final List<QuestionText> questionText;
  final String correctAnswer;
  final String correctMessage;
  final List<MyAnswerOption> choices;
  bool isSelected;
  String? selectedAnswer;
  bool isCorrect;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.correctMessage,
    required this.choices,
    this.isSelected = false,
    this.selectedAnswer,
    this.isCorrect = false,
  });

  void setSelected(String answer) {
    isSelected = true;
    selectedAnswer = answer;
    for (int i = 0; i < choices.length; i++) {
      if (choices[i].text == answer) {
        choices[i].isSelected = true;
        if (correctAnswer == answer) {
          choices[i].isCorrect = true;
        }
      }
    }
  }
}

class QuestionText {
  final String text;
  final String type;
  final String subType;

  QuestionText({
    required this.text,
    required this.type,
    required this.subType,
  });
}
