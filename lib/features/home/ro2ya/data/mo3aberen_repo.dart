import 'dart:developer';

import 'package:dreams/const/urls.dart';
import 'package:dreams/features/home/ro2ya/data/models/dreams_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:dreams/utils/network_client.dart';

class MoaberenRepo {
  final client = NetworkClient();

  Future<MoaberenData> getMoaberenList([String? page]) async {
    final url = page ?? URLs.GET_MOABERENLIST;
    final res = await client.getRequest(url);
    return MoaberenModel.fromMap(res).data;
  }

  Future<QuestionsModel> getQuestions() async {
    const url = URLs.GET_QUESTIONS;
    final res = await client.getRequest(url);
    return QuestionsModel.fromMap(res);
  }

  Future submitQuestion(Map<String, dynamic> body) async {
    const url = URLs.SUBMIT_QUESTION;
    final res = await client.postRequest(url, body);
    return (res);
  }

  Future<DreamsModel> getMyDreams([String? page]) async {
    final url = page ?? URLs.MY_DREAMS;
    final res = await client.getRequest(url);
    return DreamsModel.fromMap(res);
  }

  Future submitAnswer(Map body) async {
    final id = "${body.remove('id')}";
    final url = URLs.ANSWER_DREAM + id;
    final res = await client.postRequest(url, body);
    return (res);
  }
}
