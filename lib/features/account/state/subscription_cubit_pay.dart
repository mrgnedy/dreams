import 'dart:convert';
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
      if (data.status == SubscriptionStatus.approved ||
          data.status == SubscriptionStatus.active) {
        // TODO
      }
      emit(state.copyWith(
          createdSubscription: data, state: Result.success(data)));
    } on ApiException catch (e) {
      log("error creating subscription: $e");
      emit(state.copyWith(state: Result.error('${e.errorDescription}')));
    }
  }

                                          cancelSubscription(
    String subscriptionId, {
    String reason = '',
    bool listen = true,
  }) async {
    // if (!listen) {
    //   return repo.cancelSubscription(
    //     subscriptionId,
    //     reason: reason,
    //   );
    // }
    try {
      emit(state.copyWith(state: const Result.loading()));
      log('Cancelling');
      final data =
          await repo.cancelSubscription(subscriptionId, reason: reason);
      emit(state.copyWith(createdSubscription: null));
    } on ApiException catch (e) {
      log("error cancel subscription: $e");
      emit(state.copyWith(state: Result.error('${e.errorDescription}')));
    }
  }

  getSubscriptionDetails(String subscriptionId, {bool listen = true}) async {
    log('SubId: $subscriptionId');
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.getSubscriptionDetails(subscriptionId);
      emit(
        state.copyWith(
          createdSubscription: data,
          state: listen ? Result.success(data.status) : null,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(
          state: listen ? Result.error('${e.errorDescription}') : null));
    }
  }

  subscribe() async {
    emit(state.copyWith(state: const Result.loading()));
    final userSubId = di<AuthCubit>().state.subscriptionData?.subscriptionId;
    if (userSubId != null) {
      await cancelSubscription(
        userSubId,
        reason: "Changed subscription",
        listen: false,
      );
    }
    try {
      final data = await repo.subscribe(
          state.selectedPackage!.type,
          state.selectedMethod!,
          state.createdSubscription!.id,
          state.createdSubscription!.status!.index);
      emit(
        state.copyWith(
          state: Result.success(data),
        ),
      );
      final pref = await SharedPreferences.getInstance();
      pref.remove('subId');
      final token = di<AuthCubit>().state.api_token;
      di<AuthCubit>().updateState(data.copyWith(api_token: token));
      pref.setString('user', di<AuthCubit>().state.toJson());
    } catch (e) {
      log('erro subscribing: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  subscriptionEdit(subsctiptionId) async {
    emit(state.copyWith(state: const Result.loading()));
    try {
      final data = await repo.subscribe(
          state.selectedPackage!.type,
          state.selectedMethod!,
          subsctiptionId,
          SubscriptionStatus
              .values[state.createdSubscription!.status!.index].name);
      emit(
        state.copyWith(
          state: Result.success(data),
        ),
      );
      final pref = await SharedPreferences.getInstance();
      pref.remove('subId');
      final token = di<AuthCubit>().state.api_token;
      di<AuthCubit>().updateState(data.copyWith(api_token: token));
      pref.setString('user', di<AuthCubit>().state.toJson());
    } catch (e) {
      log('erro subscribing: $e');
      emit(state.copyWith(state: Result.error('$e')));
    }
  }

  logActivity(String currentLink) async {
    await getSubscriptionDetails(state.createdSubscription!.id, listen: false);
    final data = {
      'subscription_id': state.createdSubscription!.id,
      'subscription_status': state.createdSubscription!.status.toString(),
      'current_link': currentLink
    };
    final activity = jsonEncode(data);
    log("logging: $activity");
    try {
      await repo.logActivity(activity);
    } catch (e) {
      log('Couldnt log activity: $e');
    }
  }

  restoreSubscription() async {
    try {
      final subData = di<AuthCubit>().state.subscriptionData;
      log('subData: $subData');
      final pref = await SharedPreferences.getInstance();
      // if (subData == null && !pref.containsKey('subId')) return;
      String subId = '';
      bool isSubscribe = true;
      var subscriptionId;
      if (pref.containsKey('subId')) {
        log("Unprocessed payment found");
        subId = pref.getString('subId')!;
      } else if (subData != null) {
        subId = subData.subscriptionId!;
        isSubscribe = false;
        subscriptionId = subData.id;
        final lastStartDate = DateTime.tryParse(subData.start_date)!;
        final lastSubDate = DateTime.tryParse(
            state.createdSubscription!.billingInfo!.lastPayment!.time!)!;
        if (lastStartDate.isBefore(lastSubDate)) {
          //   subId = subData.subscriptionId!;
          isSubscribe = true;
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
        isSubscribe
            ? await subscribe()
            : await subscriptionEdit(subscriptionId);
        pref.remove('subId');
      }
    } catch (e) {
      log('error restoring subscription: $e');
    }
  }
}
