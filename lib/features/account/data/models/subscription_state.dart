// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:paypal_sdk/subscriptions.dart';

import 'package:dreams/features/account/data/models/payment_methods.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/utils/base_state.dart';

class SubscriptionStateModel {
  final List<Plan>? planCollection;
  final Result state;
  final dynamic? selectedPlan;
  final PaymentMethods? paymentMethods;
  final String? selectedMethod;
  final Subscription? createdSubscription;
  final CardItem? selectedPackage;
  const SubscriptionStateModel({
    this.planCollection,
    this.paymentMethods,
    this.selectedMethod,
    this.selectedPlan,
    this.selectedPackage,
    this.createdSubscription,
    this.state = const Result.init(),
  });

  SubscriptionStateModel copyWith({
    List<Plan>? planCollection,
    Result? state,
    dynamic? selectedPlan,
    PaymentMethods? paymentMethods,
    String? selectedMethod,
    Subscription? createdSubscription,
    CardItem? selectedPackage,
  }) {
    return SubscriptionStateModel(
      planCollection: planCollection ?? this.planCollection,
      state: state ?? this.state,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      createdSubscription: createdSubscription ?? this.createdSubscription,
      selectedPackage: selectedPackage ?? this.selectedPackage,
    );
  }

  @override
  String toString() =>
      'SubscriptionStateModel(planCollection: $planCollection)';

  @override
  bool operator ==(covariant SubscriptionStateModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.planCollection, planCollection) &&
        other.state == state &&
        other.selectedPlan == selectedPlan &&
        other.paymentMethods == paymentMethods &&
        other.selectedMethod == selectedMethod &&
        other.createdSubscription == createdSubscription &&
        other.selectedPackage == selectedPackage;
  }

  @override
  int get hashCode {
    return planCollection.hashCode ^
        state.hashCode ^
        selectedPlan.hashCode ^
        paymentMethods.hashCode ^
        selectedMethod.hashCode ^
        createdSubscription.hashCode ^
        selectedPackage.hashCode;
  }
}
