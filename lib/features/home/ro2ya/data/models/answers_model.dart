import 'dart:convert';

import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:flutter/foundation.dart';

class QAModel {
  final List<Answer> answers;
  QAModel({
    required this.answers,
  });

  QAModel copyWith({
    List<Answer>? answers,
  }) {
    return QAModel(
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory QAModel.fromMap(Map<String, dynamic> map) {
    return QAModel(
      answers: List<Answer>.from(
        ((map['answers'] ??[]) as List ).map<Answer>(
          (x) => Answer.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory QAModel.fromJson(String source) =>
      QAModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QAModel(answers: $answers)';

  @override
  bool operator ==(covariant QAModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.answers, answers);
  }

  @override
  int get hashCode => answers.hashCode;
}

class Answer {
  final int id;
  final String answer;
  final QuestionData question;
  Answer({
    required this.id,
    required this.answer,
    required this.question,
  });

  Answer copyWith({
    int? id,
    String? answer,
    QuestionData? question,
  }) {
    return Answer(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      question: question ?? this.question,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'answer': answer,
      'question': question.toMap(),
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'].toInt() as int,
      answer: map['answer'] as String,
      question: QuestionData.fromMap(map['question'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Answer.fromJson(String source) =>
      Answer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Answer(id: $id, answer: $answer, question: $question)';

  @override
  bool operator ==(covariant Answer other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.answer == answer &&
        other.question == question;
  }

  @override
  int get hashCode => id.hashCode ^ answer.hashCode ^ question.hashCode;
}
