import 'dart:developer';

import 'package:dreams/features/account/data/account_repo.dart';
import 'package:dreams/features/account/data/models/packages_model.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionCubit extends Cubit<PackagesModel> {
  SubscriptionCubit() : super(PackagesModel());

  final repo = AccountRepo();

  getPackages() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.getPackages();
      emit(data.copyWith(state: const Result.done()));
    } catch (e) {
      print("Error getting packages:$e");
      emit(state.copyWith(state: Result.error("$e")));
    }
  }

  selectPackage(int index) {
    emit(state.copyWith(selectedPkgIndex: index));
    log("PKG: ${state.selectedPkgIndex}");
  }

  subscribe([int? pkgId]) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.subscripe(pkgId ?? state.selectedPkgIndex!);
      emit(state.copyWith(state: Result.success(data)));
    } catch (e) {
      print("Error subscirping:$e");
      emit(state.copyWith(state: Result.error("$e")));
    }
  }
}
