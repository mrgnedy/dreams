// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/features/account/data/models/subscription_model.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final String message;
  final int status_code;
  final AuthData data;
  AuthState({
    required this.message,
    required this.status_code,
    required this.data,
  });

  AuthState copyWith({
    String? message,
    int? status_code,
    AuthData? data,
  }) {
    return AuthState(
      message: message ?? this.message,
      status_code: status_code ?? this.status_code,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status_code': status_code,
      'data': data.toMap(),
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      message: map['message'] ?? '',
      status_code: map['status_code']?.toInt() ?? 0,
      data: AuthData.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthState(message: $message, status_code: $status_code, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.message == message &&
        other.status_code == status_code &&
        other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ status_code.hashCode ^ data.hashCode;
}

class AuthData {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? passwordConfirm;
  final String? oldPassword;
  final String? mobile;
  final String? image;
  final String? account_type;
  final String? api_token;
  final String? birthDate;
  final int? gender;
  final String? job;
    CountryData? city;
  final CountryData? country;
  final int? notification_status;
  final SubscriptionData? subscriptionData;
  final int? remaining_dreams;
  final String subscriptionStatus;
  final Result state;
  final List<CountryData?>? countries;
  final List<CountryData?>? cities;
  final String? smsCode;
  final String? deviceToken;
  final String? language;
  final String? createdAt;
  final bool isRemember;
  AuthData(
      {this.birthDate,
      this.gender = 1,
      this.job,
      this.city,
      this.country,
      this.id,
      this.name,
      this.email,
      this.mobile,
      this.image,
      this.account_type,
      this.passwordConfirm,
      this.oldPassword,
      this.password,
      this.api_token,
      this.notification_status,
      this.remaining_dreams,
      this.countries,
      this.cities,
      this.smsCode,
      this.isRemember = true,
      this.subscriptionStatus = '',
      this.deviceToken,
      this.subscriptionData,
      this.createdAt,
      this.language,
      this.state = const Result.init()});

  AuthData copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? passwordConfirm,
    String? oldPassword,
    String? mobile,
    String? image,
    String? account_type,
    String? api_token,
    String? birthDate,
    int? gender,
    String? job,
    CountryData? city,
    CountryData? country,
    int? notification_status,
    int? remaining_dreams,
    Result? state,
    SubscriptionData? subscriptionData,
    String? subscriptionStatus,
    List<CountryData>? countries,
    List<CountryData>? cities,
    String? smsCode,
    bool? isRemember,
    String? deviceToken,
    String? createdAt,
    String? language,
  }) {
    return AuthData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
        oldPassword: oldPassword ?? this.oldPassword,
        mobile: mobile ?? this.mobile,
        image: image ?? this.image,
        account_type: account_type ?? this.account_type,
        api_token: api_token ?? this.api_token,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        job: job ?? this.job,
        city: city ?? this.city,
        country: country ?? this.country,
        notification_status: notification_status ?? this.notification_status,
        state: state ?? this.state,
        countries: countries ?? this.countries,
        cities: cities ?? this.cities,
        isRemember: isRemember ?? this.isRemember,
        subscriptionData: subscriptionData ?? this.subscriptionData,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        remaining_dreams: remaining_dreams ?? this.remaining_dreams,
        deviceToken: deviceToken ?? this.deviceToken,
        createdAt: createdAt ?? this.createdAt,
        language: language ?? this.language,
        smsCode: smsCode ?? this.smsCode);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': image,
      'account_type': account_type,
      'api_token': api_token,
      'birthdate': birthDate,
      'gender': gender,
      'job': job,
      'city': city?.toMap(),
      'remaining_dreams': remaining_dreams,
      'country': country?.toMap(),
      'notification_status': notification_status,
      'subscription_status': subscriptionStatus,
      'device_token': deviceToken,
      'created_at': createdAt,
      'subscription': subscriptionData?.toMap(),
    };
  }

  Map<String, dynamic> toLogin() {
    return {
      'email': email,
      'password': password,
      'device_token': deviceToken,
    };
  }

  Map<String, dynamic> toReset() {
    return {
      'password': password,
      'password_confirmation': passwordConfirm,
      'sms_code': smsCode,
      'email': email
    };
  }

  Map<String, dynamic> toChangePw() {
    return {
      'password': password,
      'password_confirmation': passwordConfirm,
      'old_password': oldPassword,
    };
  }

  Map<String, dynamic> toRegister() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'birthdate': birthDate?.split('T').first,
      'password': password,
      'password_confirmation': passwordConfirm,
      "country_id": country?.id,
      "city_id": city?.id,
      'image': image,
      'job': job,
      'gender': gender,
      'notification_status': 1,
      'device_token': deviceToken,
      'lang': language,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      id: map['id']?.toInt(),
      name: map['name'],
      email: map['email'],
      mobile: map['mobile'],
      deviceToken: map['device_token'],
      image: map['image'],
      remaining_dreams: map['remaining_dreams'],
      account_type: map['account_type'],
      subscriptionData: map['subscription'] == null
          ? null
          : SubscriptionData.fromMap(map['subscription'] ?? {}),
      subscriptionStatus: map['subscription_status'],
      api_token: map['api_token'],
      birthDate: map['birthdate'],
      gender: map['gender'],
      job: map['job'],
      createdAt: map['created_at'],
      city: map['city'] != null ? CountryData.fromMap(map['city']) : null,
      country:
          map['country'] != null ? CountryData.fromMap(map['country']) : null,
      notification_status: map['notification_status']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthData(id: $id, name: $name, email: $email, mobile: $mobile, image: $image, account_type: $account_type, api_token: $api_token, notification_status: $notification_status)';
  }

  @override
  bool operator ==(covariant AuthData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.passwordConfirm == passwordConfirm &&
        other.oldPassword == oldPassword &&
        other.mobile == mobile &&
        other.image == image &&
        other.account_type == account_type &&
        other.api_token == api_token &&
        other.birthDate == birthDate &&
        other.gender == gender &&
        other.job == job &&
        other.city == city &&
        other.createdAt == createdAt &&
        other.deviceToken == deviceToken &&
        other.country == country &&
        other.notification_status == notification_status &&
        other.subscriptionData == subscriptionData &&
        other.subscriptionStatus == subscriptionStatus &&
        other.state == state &&
        other.remaining_dreams == remaining_dreams &&
        listEquals(other.countries, countries) &&
        listEquals(other.cities, cities) &&
        other.smsCode == smsCode &&
        other.isRemember == isRemember;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        passwordConfirm.hashCode ^
        oldPassword.hashCode ^
        mobile.hashCode ^
        image.hashCode ^
        account_type.hashCode ^
        api_token.hashCode ^
        birthDate.hashCode ^
        deviceToken.hashCode ^
        gender.hashCode ^
        job.hashCode ^
        city.hashCode ^
        createdAt.hashCode ^
        country.hashCode ^
        notification_status.hashCode ^
        subscriptionData.hashCode ^
        subscriptionStatus.hashCode ^
        state.hashCode ^
        countries.hashCode ^
        cities.hashCode ^
        remaining_dreams.hashCode ^
        smsCode.hashCode ^
        isRemember.hashCode;
  }
}
