import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/auth/data/auth_repo.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserType {
  static const String PROVIDER = "service_provider";
  static const String USER = "client";
}

bool isProvider() {
  if (di.isRegistered<AuthCubit>()) {
    return di<AuthCubit>().state.account_type == UserType.PROVIDER;
  } else {
    return false;
  }
}

class AuthCubit extends Cubit<AuthData> {
  AuthCubit() : super(AuthData());
  final repo = AuthRepo();
  final GlobalKey<FormState> loginFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormState = GlobalKey<FormState>();
  // final GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future getCountries() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.getCities();
      emit(state.copyWith(countries: data.data, state: Result.success(data)));
    } catch (e) {
      log('Error getting countries: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future login() async {
    if (!loginFormState.currentState!.validate()) {
      return Fluttertoast.showToast(
        msg: LocaleKeys.incorrectValidator.tr(
          args: [LocaleKeys.yourInfo.tr()],
        ),
      );
    }
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.login(state.toLogin());
      emit(data.copyWith(
          state: const Result.success(true), isRemember: state.isRemember));
      if (state.isRemember) {
        log('remembered');
        final pref = await SharedPreferences.getInstance();
        pref.setString('user', data.toJson());
      }
    } catch (e) {
      log('Error login: $e');
      // Fluttertoast.showToast(msg: '$e');
      if (e.toString().contains('verify')) {
        emit(state.copyWith(state: const Result.success(false)));
      } else {
        emit(state.copyWith(state: Result.error('$e')));
      }
    }
  }

  Future checkUser() async {
    final pref = await SharedPreferences.getInstance();
    final encodedUser = pref.getString('user');
    log('$encodedUser');
    if (encodedUser != null) emit(AuthData.fromJson(encodedUser));
  }

  Future register() async {
    if (!registerFormState.currentState!.validate()) {
      return Fluttertoast.showToast(
        msg: LocaleKeys.incorrectValidator.tr(
          args: [LocaleKeys.yourInfo.tr()],
        ),
      );
    }
    emit(state.copyWith(state: const Result.loading()));
    try {
      final mail = state.email;
      final data = await repo.register(state.toRegister());
      log("EData: ${data.toMap()}");
      emit(state.copyWith(state: const Result.success(true)));
      log("Data ${state.toLogin()}");
    } catch (e) {
      log('Error register: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future validateCode() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      log("Code: ${state.smsCode}\nmail:${state.id}");
      final data = await repo.confirmCode(state.smsCode!, state.email!);
      emit(data.copyWith(state: Result.success(data)));
      final pref = await SharedPreferences.getInstance();
      pref.setString('user', data.toJson());
    } catch (e) {
      log('Error validate: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future resetPassword() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      log("Code: ${state.smsCode}\nmail:${state.id}");
      final data = await repo.resetPassword(state.toReset());
      emit(data.copyWith(state: Result.success(data)));
      final pref = await SharedPreferences.getInstance();
      pref.setString('user', data.toJson());
    } catch (e) {
      log('Error validate: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future forgetPassword() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.forgetPassword(state.email!);
      emit(
        state.copyWith(state: Result.success(data), smsCode: "123456"),
      );
    } catch (e) {
      log('Error forget: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future resendCode() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.forgetPassword(state.email!);
      emit(data.copyWith(state: Result.done()));
    } catch (e) {
      log('Error forget: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }
  updateState(AuthData s){
    emit(s);
  }
  updateMail(String mail) {
    emit(state.copyWith(email: mail));
  }

  updateCode(String smsCode) {
    emit(state.copyWith(smsCode: smsCode, state: const Result.init()));
  }

  updateName(String name) {
    emit(state.copyWith(name: name));
  }

  updateMobile(String mobile) {
    emit(state.copyWith(mobile: mobile));
  }

  updateBirthdate(String birthdate) {
    emit(state.copyWith(birthDate: birthdate));
  }

  void updateCity(CountryData? city) {
    emit(state.copyWith(city: city));
  }

  void updateCountry(CountryData? country) {
    emit(state.copyWith(country: country, cities: country?.cities));
    log("cl: ${state.country}");
  }

  updatePassword(String password) {
    emit(
      state.copyWith(password: password, state: const Result.init()),
    );
  }

  updateJob(String job) {
    log('$job');
    emit(
      state.copyWith(job: job, state: const Result.init()),
    );
  }

  updateGender(int gender) {
    emit(
      state.copyWith(gender: gender, state: const Result.init()),
    );
  }

  updateConfirmPassword(String password) {
    emit(
      state.copyWith(passwordConfirm: password, state: const Result.init()),
    );
  }

  updateRemember(bool isRemember) {
    emit(
      state.copyWith(isRemember: isRemember, state: const Result.init()),
    );
  }
}
