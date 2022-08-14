import 'dart:developer';

import 'package:dreams/features/account/data/account_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/base_state.dart';

class AccountCubit extends Cubit<Result> {
  AccountCubit() : super(const Result.init());

  GlobalKey<FormState> contactusState = GlobalKey();
  final repo = AccountRepo();
  contactUs(String title, String mail, String message) async {

    if(!contactusState.currentState!.validate()) return;
    emit(const Result.loading());
    try {
      final data = await repo.contactUs(title, mail, message);
      emit(Result.done());
    } catch (e) {
      log('error contactUs: $e');
      emit(Result.error('$e'));
    }
  }
}
