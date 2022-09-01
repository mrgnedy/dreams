import 'dart:developer';

import 'package:dreams/const/urls.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/utils/network_client.dart';

class AuthRepo {
  final client = NetworkClient();
  Future updateNotificationToken(String token) async {
    const url = URLs.UPDATE_NOTIFICATION_TOKEN;
    final body = {"device_token": token};
    final req = client.postRequest(url, body);
    return await req;
  }

  Future<AuthData> updateNotificationStatus(int status) async {
    const url = URLs.UPDATE_NOTIFICATION_STATUS;
    final req = client.getRequest(url, );
    return AuthState.fromMap(await req).data;
  }

  Future<CountryModel> getCities() async {
    const url = URLs.CITIES;
    final req = client.getRequest(url);
    return CountryModel.fromMap(await req);
  }

  Future<AuthData> login(Map loginData) async {
    const url = URLs.LOGIN;
    final req = client.postRequest(url, loginData);
    return AuthState.fromMap(await req).data;
  }

  Future<AuthData> register(Map registerData) async {
    const url = URLs.REGISTER;
    final req = client.postRequest(url, registerData);
    return AuthState.fromMap(await req).data;
  }

  Future<AuthData> updateProfile(Map registerData) async {
    const url = URLs.UPDATE_PROFILE;
    registerData.removeWhere((key, value) => value == null);
    final body = registerData
        .map<String, String>((key, value) => MapEntry(key, value.toString()));
    dynamic req;
    if (registerData["image"]?.contains('http') == true|| registerData["image"]==null) {
      req = await client.postRequest(url, body..remove('image'));
    } else {
      req =
          await client.postWithFile(url, body, registerData["image"], "image");
    }
    log('IMAGE Iz: ${req['data']['image']}');
    return AuthState.fromMap(req).data;
  }

  Future<AuthData> confirmCode(String code, String email) async {
    const url = URLs.CODE_CONFIRM;
    final body = {"sms_code": code, "email": email};
    final req = client.postRequest(url, body);
    return AuthState.fromMap(await req).data;
  }

  Future resendCode(String mail) async {
    const url = URLs.RESEND_CODE;
    final body = {"email": mail};
    final req = client.postRequest(url, body);
    return (await req);
  }

  Future<AuthData> resetPassword(Map body) async {
    const url = URLs.NEW_PASSOWRD;
    final req = client.postRequest(url, body);
    return AuthState.fromMap(await req).data;
  }

  Future changePassword(Map body) async {
    const url = URLs.CHANGE_PASSWORD;
    final req = client.postRequest(url, body);
    return req;
  }

  Future forgetPassword(String mail) async {
    const url = URLs.FORGET_PASSWORD;
    final body = {'email': mail};
    final req = client.postRequest(url, body);
    return (await req);
  }
}
