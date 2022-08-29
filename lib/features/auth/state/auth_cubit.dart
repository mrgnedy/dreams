import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/state/subscription_cubit_pay.dart';
import 'package:dreams/features/auth/data/auth_repo.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/features/locale_cubit.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/fcm_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserType {
  static const String PROVIDER = "service_provider";
  static const String USER = "client";
  static const String GUEST = "client";
}

bool isProvider() {
  if (di.isRegistered<AuthCubit>()) {
    return di<AuthCubit>().state.account_type == UserType.PROVIDER;
  } else {
    return false;
  }
}

bool isGeust() {
  if (di.isRegistered<AuthCubit>()) {
    return di<AuthCubit>().state.account_type == null;
  } else {
    return false;
  }
}

class AuthCubit extends Cubit<AuthData> {
  AuthCubit() : super(AuthData());
  final repo = AuthRepo();
  final GlobalKey<FormState> loginFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> codeFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> sendCodeFormState = GlobalKey<FormState>();
  final GlobalKey<FormState> resetFormState = GlobalKey<FormState>();
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

  Future logout(BuildContext context) async {
    updateNotificationToken('');
    FCMHelper.unregisterToken();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    await di.reset();
    di.registerLazySingleton(() => AuthCubit());
    di.registerLazySingleton(() => LocaleCubit());
    MyApp.restart(context);
  }

  Future login() async {
    updateDeviceToken(FCMHelper.token!);
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
      updateNotificationToken(FCMHelper.token!);
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
    await SubscriptionPayCubit().restoreSubscription();
    await SubscriptionPayCubit().close();
  }

  Future register() async {
    updateDeviceToken(FCMHelper.token!);
    if (!registerFormState.currentState!.validate()) {
      return Fluttertoast.showToast(
        msg: LocaleKeys.incorrectValidator.tr(
          args: [LocaleKeys.yourInfo.tr()],
        ),
      );
    }
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.register(state.toRegister());
      log("EData: ${data.toMap()}");
      emit(state.copyWith(state: const Result.success(true)));
      log("Data ${state.toLogin()}");
    } catch (e) {
      log('Error register: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  updateNotificationToken(String token) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.updateNotificationToken(token);
      emit(state.copyWith(state: const Result.done()));
    } catch (e) {
      log("error updating notification: $e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  updateNotificationStatus(int status) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.updateNotificationStatus(status);
      emit(data.copyWith(state: const Result.done()));
      final pref = await SharedPreferences.getInstance();
      pref.setString('user', state.toJson());
    } catch (e) {
      log("error updating notification_status: $e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future updateProfile() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.updateProfile(state.toRegister());
      log("Image iz: ${data.image}");
      emit(data.copyWith(state: const Result.done()));
      final pref = await SharedPreferences.getInstance();
      pref.setString('user', state.toJson());
    } catch (e) {
      log('Error updateProfile: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future validateCode() async {
    if (!codeFormState.currentState!.validate()) {
      return Fluttertoast.showToast(
        msg: LocaleKeys.incorrectValidator.tr(
          args: [LocaleKeys.yourInfo.tr()],
        ),
      );
    }
    emit(state.copyWith(state: const Result.loading()));
    try {
      log("Code: ${state.smsCode}\nmail:${state.id}");
      final smsCode = state.smsCode;
      final data = await repo.confirmCode(state.smsCode!, state.email!);
      emit(data.copyWith(state: Result.success(data), smsCode: smsCode));
      final pref = await SharedPreferences.getInstance();
      pref.setString('user', data.toJson());
    } catch (e) {
      log('Error validate: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future resetPassword() async {
    if (!resetFormState.currentState!.validate()) {
      return Fluttertoast.showToast(
        msg: LocaleKeys.incorrectValidator.tr(
          args: [LocaleKeys.yourInfo.tr()],
        ),
      );
    }
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
    if (!sendCodeFormState.currentState!.validate()) {
      return Fluttertoast.showToast(
        msg: LocaleKeys.incorrectValidator.tr(
          args: [LocaleKeys.email.tr()],
        ),
      );
    }
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

  Future changePassword() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.changePassword(state.toChangePw());
      emit(
        state.copyWith(state: Result.success(data), smsCode: "123456"),
      );
    } catch (e) {
      log('Error change PW: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  Future resendCode() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.resendCode(state.email!);
      emit(state.copyWith(state: Result.done()));
    } catch (e) {
      log('Error forget: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  updateState(AuthData s) {
    emit(s);
  }

  updateDeviceToken(String token) {
    emit(state.copyWith(deviceToken: token, state: const Result.init()));
  }

  updateMail(String mail) {
    emit(state.copyWith(email: mail, state: const Result.init()));
  }

  updateCode(String smsCode) {
    emit(state.copyWith(smsCode: smsCode, state: const Result.init()));
  }

  updateName(String name) {
    emit(state.copyWith(name: name, state: const Result.init()));
  }

  updateMobile(String mobile) {
    emit(state.copyWith(mobile: mobile, state: const Result.init()));
  }

  updateBirthdate(String birthdate) {
    emit(state.copyWith(birthDate: birthdate, state: const Result.init()));
  }

  void updateCity(CountryData? city) {
    emit(state.copyWith(city: city, state: const Result.init()));
  }

  void updateCountry(CountryData? country) {
    emit(state.copyWith(
        country: country, cities: country?.cities, state: const Result.init()));
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

  updateGender(num gender) {
    emit(
      state.copyWith(gender: gender.toInt(), state: const Result.init()),
    );
  }

  updateConfirmPassword(String password) {
    emit(
      state.copyWith(passwordConfirm: password, state: const Result.init()),
    );
  }

  updateOldPassword(String password) {
    emit(
      state.copyWith(oldPassword: password, state: const Result.init()),
    );
  }

  updateRemember(bool isRemember) {
    emit(
      state.copyWith(isRemember: isRemember, state: const Result.init()),
    );
  }

  updateImage(String imgPath) {
    emit(
      state.copyWith(image: imgPath, state: const Result.init()),
    );
  }
}
