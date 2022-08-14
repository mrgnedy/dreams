import 'dart:developer';

import 'package:dreams/features/home/ro2ya/data/mo3aberen_repo.dart';
import 'package:dreams/features/home/ro2ya/data/models/dreams_model.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercharged/supercharged.dart';

class MyRo2yasCubit extends Cubit<DreamsModel> {
  MyRo2yasCubit() : super(DreamsModel());
  final repo = MoaberenRepo();

  getMyDreams([bool isLoadMore = false]) async {
    try {
      if ((state.paginationLinks != null &&
              state.paginationLinks!.first.isNotEmpty &&
              state.paginationLinks!.next == null &&isLoadMore ) ||
          state.state is LoadingResult) return;
      emit(state.copyWith(state: const Result.loading()));
      
      final data = await repo.getMyDreams(isLoadMore? state.paginationLinks?.next:null);
      if(!isLoadMore ) emit(state.copyWith(data: []));
      emit(data.copyWith(
          state: const Result.success(true),
          data: [...state.data, ...data.data]
           ));
      // .associateBy(((a) => a.id)).values.toList(  )

    } catch (e) {
      log("error getting my dreams :$e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  submitAnswer(id) async {
    emit(state.copyWith(state: const Result.loading()));
    // try {
    final data = await repo.submitAnswer(state.toAnswer(id));
    emit(state.copyWith(state: const Result.success(true)));
    // } catch (e) {
    //   log("error submitting answer :$e");
    //   emit(state.copyWith(state: Result.error('$e')));
    // }
  }

  updateTafser(String tafser) {
    emit(state.copyWith(state: const Result.init(), submitTafser: tafser));
  }

  updateEstedlal(String estedlal) {
    emit(state.copyWith(state: const Result.init(), submitEstedlal: estedlal));
  }
}
