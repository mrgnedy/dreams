import 'dart:developer';

import 'package:dreams/features/account/data/models/subscription_state.dart';
import 'package:dreams/features/account/data/subscription_repo.dart';
import 'package:dreams/features/account/ui/subscriptions.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paypal_sdk/core.dart';
import 'package:paypal_sdk/subscriptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPayCubit extends Cubit<SubscriptionStateModel> {
  SubscriptionPayCubit() : super(const SubscriptionStateModel());

  final repo = SubscriptionRepo();

  getPlans() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final plans = await repo.getPlansList();
      emit(state.copyWith(planCollection: plans, state: Result.success(plans)));
    } on ApiException catch (e) {
      log('error getting plans: $e');
      emit(state.copyWith(state: Result.error('${e.errorDescription}')));
    }
  }

  getPaymentMethods() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final methods = await repo.getPaymentMethods();
      emit(state.copyWith(paymentMethods: methods, state: const Result.init()));
    } catch (e) {
      log('error getting methods: $e');
    }
  }

  updatePaymentMethod(String method) {
    emit(state.copyWith(selectedMethod: method));
  }

  selectPlan(dynamic plan) {
    emit(state.copyWith(selectedPlan: plan));
  }

  selectPkg(CardItem pkg) {
    emit(state.copyWith(selectedPackage: pkg));
  }

  makeSubscription(dynamic plan) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.createSubscription(plan);
      emit(state.copyWith(
          createdSubscription: data, state: Result.success(data)));
    } on ApiException catch (e) {
      log("error creating subscription: $e");
      emit(state.copyWith(state: Result.error('${e.errorDescription}')));
    }
  }

  cancelSubscription(String subscriptionId, {String reason = ''}) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data =
          await repo.cancelSubscription(subscriptionId, reason: reason);
      emit(state.copyWith(createdSubscription: null));
    } on ApiException catch (e) {
      log("error creating subscription: $e");
      emit(state.copyWith(state: Result.error('${e.errorDescription}')));
    }
  }

  getSubscriptionDetails(String subscriptionId) async {
    log('SubId: $subscriptionId');
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.getSubscriptionDetails(subscriptionId);
      emit(
        state.copyWith(
          createdSubscription: data,
          state: Result.success(data.status),
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(state: Result.error('${e.errorDescription}')));
    }
  }

  subscribe() async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.subscribe(
          state.selectedPackage!.type, state.selectedMethod!);
      emit(
        state.copyWith(
          state: Result.success(data),
        ),
      );
      final pref = await SharedPreferences.getInstance();
      pref.remove('subId');
      final token = di<AuthCubit>().state.api_token;
      di<AuthCubit>().updateState(data.copyWith(api_token: token));
      pref.setString('user',  di<AuthCubit>().state.toJson());
    } catch (e) {
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  restoreSubscription() async {
    try {
      final subData = di<AuthCubit>().state.subscriptionData;
      log('subData: $subData');
      final pref = await SharedPreferences.getInstance();
      if (subData == null && !pref.containsKey('subId')) return;
      String subId = '';
      if (pref.containsKey('subId')) {
        log("Un processed payment found");
        subId = pref.getString('subId')!;
      } else if (subData != null) {
        final lastStartDate = DateTime.tryParse(subData.start_date)!;
        final lastSubDate = DateTime.tryParse(
            state.createdSubscription!.billingInfo!.lastPayment!.time!)!;
        if (lastStartDate.isBefore(lastSubDate)) {
          subId = subData.subscriptionId!;
        }
      }
      if (subId.isNotEmpty) {
        log("Processing payment");

        await getSubscriptionDetails(subId);
        final planId = state.createdSubscription!.planId;
        final pkgId = SubscriptionSelector.values
            .firstWhere((element) => element.getData().id == planId)
            .getData();
        updatePaymentMethod('paypal');
        selectPkg(pkgId);
        await subscribe();
        pref.remove('subId');
      }
    } catch (e) {}
  }
}
