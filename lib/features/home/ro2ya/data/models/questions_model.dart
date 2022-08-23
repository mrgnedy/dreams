// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:dreams/utils/base_state.dart';

class QuestionsModel {
  final String? message;
  final int? status_code;
  final List<QuestionData>? data;
  final Map<int, String> answers;
  final int? interId;
  final String title;
  final bool shouldShow;
  final Result state;
  QuestionsModel(
      {this.message,
      this.status_code,
      this.data,
      this.interId,
      this.shouldShow = true,
      this.title = '',
      this.answers = const {},
      this.state = const Result.init()});

  QuestionsModel copyWith({
    String? message,
    int? status_code,
    List<QuestionData>? data,
    Map<int, String>? answers,
    int? interId,
    String? title,
    Result? state,
    bool? shouldShow,
  }) {
    return QuestionsModel(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
      title: title ?? this.title,
      answers: answers ?? this.answers,
      state: state ?? this.state,
      shouldShow: shouldShow ?? this.shouldShow,
      interId: interId ?? this.interId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "answers": answers.map((key, value) => MapEntry('$key', value)),
      "title": title,
      "show": shouldShow ? 1 : 0,
      "interpreter_id": interId,
    };
    return {
      'message': message,
      'status_code': status_code,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory QuestionsModel.fromMap(Map<String, dynamic> map) {
    return QuestionsModel(
      message: map['message'] ?? '',
      status_code: map['status_code']?.toInt() ?? 0,
      data: List<QuestionData>.from(
          map['data']?.map((x) => QuestionData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionsModel.fromJson(String source) =>
      QuestionsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuestionsModel(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(covariant QuestionsModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status_code == status_code &&
        listEquals(other.data, data) &&
        mapEquals(other.answers, answers) &&
        other.interId == interId &&
        other.title == title &&
        other.shouldShow == shouldShow &&
        other.state == state;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status_code.hashCode ^
        data.hashCode ^
        answers.hashCode ^
        interId.hashCode ^
        title.hashCode ^
        shouldShow.hashCode ^
        state.hashCode;
  }
}

class QuestionData {
  final int id;
  final String question;
  final int is_required;
  final dynamic selects;
  final String? placeHolder;
  final String type;
  QuestionData({
    required this.id,
    required this.question,
    required this.is_required,
    required this.selects,
    required this.type,
    this.placeHolder,
  });

  QuestionData copyWith({
    int? id,
    String? question,
    int? is_required,
    dynamic selects,
    String? placeHolder,
    String? type,
  }) {
    return QuestionData(
      id: id ?? this.id,
      question: question ?? this.question,
      is_required: is_required ?? this.is_required,
      selects: selects ?? this.selects,
      placeHolder: placeHolder ?? this.placeHolder,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'is_required': is_required,
      'selects': (selects is Iterable
          ? selects.map((x) => x.toMap()).toList()
          : selects),
    };
  }

  factory QuestionData.fromMap(Map<String, dynamic> map) {
    return QuestionData(
      id: map['id']?.toInt() ?? 0,
      question: map['question'] ?? '',
      placeHolder: map['placeholder'] ?? '',
      type: map['type'] ?? '',
      is_required: map['is_required']?.toInt() ?? 0,
      selects: (map['selects'] is List)
          ? List<Select>.from(map['selects']?.map((x) => Select.fromMap(x)))
          : map['selects'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionData.fromJson(String source) =>
      QuestionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(id: $id, question: $question, is_required: $is_required, selects: $selects)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionData &&
        other.id == id &&
        other.question == question &&
        other.is_required == is_required &&
        listEquals(other.selects, selects);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        is_required.hashCode ^
        selects.hashCode;
  }
}

class Select {
  final int id;
  final String answer;
  Select({
    required this.id,
    required this.answer,
  });

  Select copyWith({
    int? id,
    String? answer,
  }) {
    return Select(
      id: id ?? this.id,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answer': answer,
    };
  }

  factory Select.fromMap(Map<String, dynamic> map) {
    return Select(
      id: map['id']?.toInt() ?? 0,
      answer: map['answer'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Select.fromJson(String source) => Select.fromMap(json.decode(source));

  @override
  String toString() => 'Select(id: $id, answer: $answer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Select && other.id == id && other.answer == answer;
  }

  @override
  int get hashCode => id.hashCode ^ answer.hashCode;
}
