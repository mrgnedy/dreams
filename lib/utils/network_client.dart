// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/locale_cubit.dart';
import 'package:dreams/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class NetworkClient {
  String get tempToken => '';
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Accept-Language": di<LocaleCubit>().state.languageCode,
        'Authorization': "Bearer " + (di<AuthCubit>().state.api_token ?? "")
      };

  // getRequest(String url, {headers}) {}
  Future getRequest(url, {headers}) async {
    log("Get request: $url\nToken: ${di<AuthCubit>().state.api_token ?? ''}");
    try {
      final response = await get(Uri.parse(url), headers: this.headers);
      return checkResponse(response);
    } on SocketException catch (e) {
      log("$e");
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      log("$e");
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      log("$e");
      throw 'Bad response';
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  Future postRequest(String url, var body, {headers}) async {
    log('Posting request $url');
    log("$body");
    final uri = Uri.parse(url);
    try {
      final response =
          await post(uri, body: json.encode(body), headers: this.headers);
      return checkResponse(response);
    } on SocketException catch (e) {
      log("$e");
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      log("$e");
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      log("$e");
      throw 'Bad response';
    } on Exception catch (e) {
      log('post file request error $e');
      rethrow;
    }
  }

  Future postWithFile(
      String url, Map<String, String> body, String file, String fileKey) async {
    if (file.isEmpty) return postRequest(url, body);
    final request = MultipartRequest("POST", Uri.parse(url));
    log("Posting $body with file $file");
    request.fields.addAll(body);
    request.files.add(await MultipartFile.fromPath(fileKey, file));
    request.headers.addAll((headers));
    try {
      final streamResponse = await request.send();
      if (streamResponse.statusCode != 200 && streamResponse.statusCode != 201)
        return throw "Error ${streamResponse.statusCode}";
      final response = utf8.decode(await streamResponse.stream.first);
      final Map decodedData = json.decode(response);
      log("$decodedData");
      if (decodedData['status_code'] == 200)
        return decodedData;
      else
        throw decodedData['message'];
    } on SocketException catch (e) {
      log("$e");
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      log("$e");
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      log("$e");
      throw 'Bad response';
    } catch (e) {
      log('post file error $e');
      rethrow;
    }
    // log(decodedData);
  }

  checkResponse(Response response) {
    log('checking response');
    log("${response.body}");
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final responseData = json.decode(response.body);

      log("$responseData");
      if (responseData['status_code'] >= 200 &&
          responseData['status_code'] < 300)
        return responseData;
      else
        throw responseData['message'];
    } else {
      Map responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw 'تعذر الإتصال';
      }
      final msg = responseData['message'] ?? "تعذر الإتصال";
      Fluttertoast.showToast(msg: '$msg');
      throw msg;
    }
  }
}
