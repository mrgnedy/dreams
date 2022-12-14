import 'dart:developer';

import 'package:dreams/const/urls.dart';
import 'package:dreams/features/account/data/models/payment_methods.dart';
import 'package:dreams/utils/network_client.dart';
import 'package:paypal_sdk/catalog_products.dart';
import 'package:paypal_sdk/core.dart';
import 'package:paypal_sdk/subscriptions.dart';

import '../../auth/data/models/auth_state.dart';

const _clientId =
    'AV_aKo1XKk6fFe-Q9KQjxukEBj8a3Raw8I6Lg-PzPQ6GDulNGIalt_fURrdM4cnonqIG_3PNl12UjQUM';
const _clientSecret =
    'EFu-lpRcGhdkbYT64BEuwSl7oiYfnbS7vkE5p12u1GnWyO9Nv_hAIls-enHbDt0i74C5AMRzgRtnjjvq';

class SubscriptionRepo {
  AccessToken? accessToken;
  late PayPalEnvironment paypalEnvironment;
  late PayPalHttpClient payPalHttpClient;
  late SubscriptionsApi subscriptionsApi;
  late CatalogProductsApi productsApi;

  final client = NetworkClient();
  SubscriptionRepo() {
    paypalEnvironment = const PayPalEnvironment.sandbox(
      clientId: _clientId,
      clientSecret: _clientSecret,
    );
    payPalHttpClient = PayPalHttpClient(
      paypalEnvironment,
      accessToken: accessToken,
      accessTokenUpdatedCallback: (token) async {
        accessToken = token;
        // Persist token for re-use
      },
    );
    subscriptionsApi = SubscriptionsApi(payPalHttpClient);
    productsApi = CatalogProductsApi(payPalHttpClient);
  }

  Future<List<Plan>> getPlansList() async {
    final planIds = [
      "P-3JK30822JF059184UMMG5UQA",
      "P-53Y48101S1563192CMMG5RCY",
      "P-9G3484247S016552DMMHV3BA",
    ];
    List<Plan> plans = [];
    for (var id in planIds) {
      var planDetails = await subscriptionsApi.showPlanDetails(id);
      //(totalRequired: true, planIds: 'P-22F40098RD158310MMMFUZUQ');//(page:18, pageSize: 3);
      plans.add(planDetails);
      log("PKGG $planDetails");
    }
    return plans;
  }

  Future<PaymentMethods> getPaymentMethods() async {
    const url = URLs.PAYMENT_METHODS;
    final req = await client.getRequest(url);

    return PaymentMethodsModel.fromMap(req).data;
  }

  Future<Subscription> getSubscriptionDetails(String subscriptionId) async {
    var sub = await subscriptionsApi.showSubscriptionDetails(subscriptionId);
    log("$sub");
    return sub;
  }

  Future<Subscription> createSubscription(
    dynamic billingPlan,
  ) async {
    var createSubscriptionRequest = SubscriptionRequest(
      // plan: billingPlan,
      planId: billingPlan,
      // applicationContext: const ApplicationContext(
      //     returnUrl: 'com.gulfterminal.dreams://paypalpay',
      //     cancelUrl: 'https://youtube.com')
      // customId: 'custom_id',
    );
    var subscription =
        await subscriptionsApi.createSubscription(createSubscriptionRequest);
    log(subscription.id);
    return subscription;
  }

  Future<void> cancelSubscription(
    String subscriptionId, {
    String reason = '',
  }) async {
    await subscriptionsApi.cancelSubscription(subscriptionId, reason);
    log('Cancelled: $subscriptionId');
  }

  Future logActivity(String activity) async {
    const url = URLs.LOG_ACTIVITY;
    final body = {"log": activity};
    return await client.postRequest(url, body);
  }

  Future<AuthData> subscribe(int pkgId, String paymentMethod,
      String subscriptionId, subscriptionStatus) async {
    const url = URLs.SUBSCRIBE;
    final body = {
      "package_id": pkgId,
      "payment_methods": paymentMethod,
      "subscription_id": subscriptionId,
      "subscription_status": subscriptionStatus,
    };
    final req = await client.postRequest(url, body);
    return AuthState.fromMap(await req).data;
  }

  Future<AuthData> subscriptionEdit(
    int pkgId,
    String paymentMethod,
    String subscriptionId,
    subscriptionStatus,
  ) async {
    final url = URLs.SUBSCRIBE + subscriptionId;
    final body = {
      "package_id": pkgId,
      "payment_methods": paymentMethod,
      "subscription_id": subscriptionId,
      "subscription_status": subscriptionStatus,
    };
    final req = await client.postRequest(url, body);
    return AuthState.fromMap(await req).data;
  }
}
