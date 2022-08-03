// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dreams/features/home/ro2ya/data/models/answers_model.dart';
import 'package:flutter/foundation.dart';

import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:dreams/utils/base_state.dart';

class DreamsModel {
  final String? message;
  final int? status_code;
  final List<DreamData>? data;
  final Result state;
  final String? submitTafser;
  final String? submitEstedlal;
  DreamsModel(
      {this.submitTafser,
      this.submitEstedlal,
      this.message,
      this.status_code,
      this.data,
      this.state = const Result.init()});

  DreamsModel copyWith({
    String? message,
    int? status_code,
    List<DreamData>? data,
    Result? state,
    String? submitTafser,
    String? submitEstedlal,
  }) {
    return DreamsModel(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
      state: state ?? this.state,
      submitTafser: submitTafser ?? this.submitTafser,
      submitEstedlal: submitEstedlal ?? this.submitEstedlal,
    );
  }

  Map<String, dynamic> toAnswer(dreamId) {
    return <String, dynamic>{
      'interpreter_answer': submitTafser,
      'id': status_code,
      'interpreter_answer2': submitEstedlal
    };
  }

  factory DreamsModel.fromMap(Map<String, dynamic> map) {
    return DreamsModel(
      message: map['message'] as String,
      status_code: map['status_code'].toInt() as int,
      data: List<DreamData>.from(
        (map['data']['data'] as List<dynamic>).map<DreamData>(
          (x) => DreamData.fromMap(x),
        ),
      ),
    );
  }

  factory DreamsModel.fromJson(String source) =>
      DreamsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DreamsModel(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(covariant DreamsModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status_code == status_code &&
        listEquals(other.data, data) &&
        other.state == state;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        status_code.hashCode ^
        data.hashCode ^
        state.hashCode;
  }
}

class DreamData {
  final int id;
  final String title;
  final int user_id;
  final int interpreter_id;
  final MoaberData interpreter;
  final List<QAModel> answers;
  final String interpreter_answer;
  final String interpreter_answer2;
  final String createdAt;
  final String status;
  DreamData({
    required this.id,
    required this.title,
    required this.user_id,
    required this.interpreter_id,
    required this.interpreter,
    required this.answers,
    required this.interpreter_answer,
    required this.interpreter_answer2,
    required this.createdAt,
    required this.status,
  });

  DreamData copyWith({
    int? id,
    String? title,
    int? user_id,
    int? interpreter_id,
    MoaberData? interpreter,
    List<QAModel>? answers,
    String? interpreter_answer,
    String? interpreter_answer2,
    String? createdAt,
    String? status,
  }) {
    return DreamData(
      id: id ?? this.id,
      title: title ?? this.title,
      user_id: user_id ?? this.user_id,
      interpreter_id: interpreter_id ?? this.interpreter_id,
      interpreter: interpreter ?? this.interpreter,
      answers: answers ?? this.answers,
      interpreter_answer: interpreter_answer ?? this.interpreter_answer,
      interpreter_answer2: interpreter_answer2 ?? this.interpreter_answer2,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'user_id': user_id,
      'interpreter_id': interpreter_id,
      'interpreter': interpreter.toMap(),
      'answers': answers,
      'interpreter_answer': interpreter_answer,
      'interpreter_answer2': interpreter_answer2,
      'created_at': interpreter_answer2,
    };
  }

  factory DreamData.fromMap(Map<String, dynamic> map) {
    return DreamData(
      id: map['id'].toInt() as int,
      title: map['title'] as String,
      user_id: map['user_id'].toInt() as int,
      interpreter_id: map['interpreter_id'].toInt() as int,
      interpreter: MoaberData.fromMap((map['interpreter'] ?? {})),
      answers:
          List<QAModel>.from((map['answers']).map((e) => QAModel.fromMap(e))),
      interpreter_answer: map['interpreter_answer'] as String,
      interpreter_answer2: map['interpreter_answer2'] as String,
      createdAt: map['created_at'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DreamData.fromJson(String source) =>
      DreamData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DreamData(id: $id, title: $title, user_id: $user_id, interpreter_id: $interpreter_id, interpreter: $interpreter, answers: $answers, interpreter_answer: $interpreter_answer)';
  }

  @override
  bool operator ==(covariant DreamData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.user_id == user_id &&
        other.interpreter_id == interpreter_id &&
        other.interpreter == interpreter &&
        other.status == status &&
        other.createdAt == createdAt &&
        listEquals(other.answers, answers) &&
        other.interpreter_answer2 == interpreter_answer2 &&
        other.interpreter_answer == interpreter_answer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        user_id.hashCode ^
        interpreter_id.hashCode ^
        interpreter.hashCode ^
        answers.hashCode ^
        interpreter_answer2.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        interpreter_answer.hashCode;
  }
}
