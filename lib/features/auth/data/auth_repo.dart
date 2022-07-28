import 'package:dreams/const/urls.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/utils/network_client.dart';

class AuthRepo {
  final client = NetworkClient();
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

  Future forgetPassword(String mail) async {
    const url = URLs.FORGET_PASSWORD;
    final body = {'email': mail};
    final req = client.postRequest(url, body);
    return (await req);
  }
}
