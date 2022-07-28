// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class NetworkClient {
  String get tempToken => '';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  // getRequest(String url, {headers}) {}
  Future getRequest(url, {headers}) async {
    try {
      final response = await get(Uri.parse(url),
          headers: headers ?? (this.headers..['Authorization'] = tempToken));
      return checkResponse(response);
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future postRequest(String url, var body, {headers}) async {
    print('Posting request $url');
    print(body);
    final uri = Uri.parse(url);
    try {
      final response = await post(uri,
          body: json.encode(body),
          headers: headers ?? (this.headers..['Authorization'] = tempToken));
      return checkResponse(response);
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } on Exception catch (e) {
      print('post file request error $e');
      rethrow;
    }
  }

  Future postWithFile(
      String url, Map<String, String> body, String file, String fileKey) async {
    final request = MultipartRequest("POST", Uri.parse(url));
    print("Posting $body with file $file");
    request.fields.addAll(body..removeWhere((key, value) => value == null));
    request.files.add(await MultipartFile.fromPath(fileKey, file));
    request.headers.addAll(headers..['Authorization'] = tempToken);
    try {
      final streamResponse = await request.send();
      if (streamResponse.statusCode != 200 && streamResponse.statusCode != 201)
        return throw "Error ${streamResponse.statusCode}";
      final response = utf8.decode(await streamResponse.stream.first);
      final Map decodedData = json.decode(response);
      print(decodedData);
      if (decodedData['statusCode'] == 200)
        return decodedData;
      else
        throw decodedData['message'];
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print('post file error $e');
      rethrow;
    }
    // print(decodedData);
  }

  checkResponse(Response response) {
    print('checking response');
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final responseData = json.decode(response.body);

      print(responseData);
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
