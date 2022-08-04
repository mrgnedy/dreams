import 'dart:developer';

import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:dreams/features/home/ro2ya/data/mo3aberen_repo.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoaberenCubit extends Cubit<MoaberenData> {
  MoaberenCubit() : super(MoaberenData());
  final repo = MoaberenRepo();
  
  Future getMoaberenList() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      if (state.links != null && state.links!.next == null) return;
      final data = await repo.getMoaberenList(state.links?.next);
      log("${data.data.length}");
      emit(
        data.copyWith(state: const Result.done(), data: [
          ...state.data,
          ...data.data,
        ]),
      );
    } catch (e) {
      log('error getting Moaberen $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }
}
