import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/home/ro2ya/data/mo3aberen_repo.dart';
import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoyaRequestCubit extends Cubit<QuestionsModel> {
  RoyaRequestCubit() : super(QuestionsModel());
  final repo = MoaberenRepo();

  final formState = GlobalKey<FormState>();
  Future getQuestions() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.getQuestions();
      emit(data.copyWith(state: const Result.done(), interId: state.interId));
    } catch (e) {
      log("error getting questions: $e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  updateAnswer(int id, String answer) {
    var answers = state.answers.map((key, value) => MapEntry(key, value));
    emit(state.copyWith(
        answers: answers..[id] = answer, state: const Result.init()));
  }

  updateTitle(String title) {
    log("${state.interId}");
    emit(state.copyWith(title: title, state: const Result.init()));
  }

  updateInterId(int id) {
    log("Inter id:$id");
    emit(state.copyWith(interId: id));
  }

  updateShouldshow() {
    emit(state.copyWith(
        shouldShow: !state.shouldShow, state: const Result.init()));
  }

  submitAnswer() async {
    if (!formState.currentState!.validate()) {
      return Fluttertoast.showToast(msg: LocaleKeys.answerAllQuestions.tr());
    }
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.submitQuestion(state.toMap());
      emit(state.copyWith(state: const Result.success(true)));
    } catch (e) {
      log("error submitting questions: $e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }
}
