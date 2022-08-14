import 'dart:developer';

import 'package:dreams/features/notfications/data/notification_model.dart';
import 'package:dreams/features/notfications/data/notification_repo.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationModel> {
  NotificationCubit() : super(NotificationModel());
  final repo = NotificationRepo();
  getNotificion() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.getNotifications();
      emit(data.copyWith(state: const Result.done()));
    } catch (e) {
      log("error gettingNotification: $e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  deleteNotification(int id) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.deleteNotifications(id);
      emit(
        state.copyWith(
          state: Result.success(id),
          data: state.data..removeWhere((element) => element.id == id),
        ),
      );
    } catch (e) {
      log("error deletingNotification: $e");
      emit(state.copyWith(state: Result.error('$e')));
    }
  }
}
