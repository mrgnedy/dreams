// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dreams/utils/draw_actions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:paypal_sdk/catalog_products.dart';
import 'package:paypal_sdk/core.dart';
import 'package:paypal_sdk/src/webhooks/webhooks_api.dart';
import 'package:paypal_sdk/subscriptions.dart';
import 'package:paypal_sdk/webhooks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _clientId =
    'AV_aKo1XKk6fFe-Q9KQjxukEBj8a3Raw8I6Lg-PzPQ6GDulNGIalt_fURrdM4cnonqIG_3PNl12UjQUM';
const _clientSecret =
    'EFu-lpRcGhdkbYT64BEuwSl7oiYfnbS7vkE5p12u1GnWyO9Nv_hAIls-enHbDt0i74C5AMRzgRtnjjvq';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AccessToken? accessToken = AccessToken.fromJson(
    await exchangeForAccessToken(),
  );

  var paypalEnvironment = const PayPalEnvironment.sandbox(
    clientId: _clientId,
    clientSecret: _clientSecret,
  );

  var payPalHttpClient = PayPalHttpClient(
    paypalEnvironment,
    client: Client(),
    accessToken: accessToken,
    accessTokenUpdatedCallback: (token) async {
      accessToken = token;
      // Persist token for re-use
    },
  );

  // await catalogProductsExamples(payPalHttpClient);
  // await subscriptionExamples(payPalHttpClient);
  // await webhookExamples(payPalHttpClient);
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: LoadSubButton(
          pay: () => subscriptionExamples(payPalHttpClient),
        ),
      ),
    ),
  ));
}

Future<Map<String, dynamic>> exchangeForAccessToken() async {
  final basicAuth =
      'Basic ' + base64.encode(utf8.encode('$_clientId:$_clientSecret'));
  const url = "https://api-m.sandbox.paypal.com/v1/oauth2/token";
  final headers = <String, String>{'authorization': basicAuth};
  const body = {"grant_type": "client_credentials"};
  final req = await post(Uri.parse(url), body: body, headers: headers);
  return jsonDecode(req.body);
}

Future<Product?> catalogProductsExamples(
    PayPalHttpClient payPalHttpClient) async {
  var productsApi = CatalogProductsApi(payPalHttpClient);
// Create product
  try {
    var createProductRequest = ProductRequest(
        name: 'test_product',
        type: ProductType.service,
        description: 'test_description');

    var product = await productsApi.createProduct(createProductRequest);
    return product;
    print(product);
  } on ApiException catch (e) {
    print(e);
  }

  // // Update product
  // try {
  //   await productsApi.updateProduct('product_id', [
  //     Patch(
  //         op: PatchOperation.replace,
  //         path: '/description',
  //         value: 'Updated description')
  //   ]);
  // } on ApiException catch (e) {
  //   print(e);
  // }
  // // List products
  // try {
  //   var productsCollection = await productsApi.listProducts();

  //   for (var product in productsCollection.products) {
  //     print(product);
  //   }
  // } on ApiException catch (e) {
  //   print(e);
  // }
  // // Get product details
  // try {
  //   var product = await productsApi.showProductDetails('product_id');
  //   print(product);
  // } on ApiException catch (e) {
  //   print(e);
  // }
}

WebViewController? _controller;

Future<void> subscriptionExamples(PayPalHttpClient payPalHttpClient) async {
  var subscriptionsApi = SubscriptionsApi(payPalHttpClient);
  final p = (await catalogProductsExamples(payPalHttpClient))!;

  // Plans
  // List plans
  // late PlanCollection planCollection;
  // try {
  //   planCollection = await subscriptionsApi.listPlans();
  //   print(planCollection);
  // } on ApiException catch (e) {
  //   print(e);
  // }
  // planCollection.plans.forEach((p) async {
  //   try {
  //     await subscriptionsApi.deactivatePlan(p.id);
  //     log("Deactivated: ${p.id}");
  //   } on ApiException catch (e) {
  //     print(e);
  //   }
  // });

  // Create plan

  late Plan billingPlan;
  try {
    var planRequest = PlanRequest(
      productId: p.id,
      name: 'Test plan',
      status: PlanStatus.active,
      description: 'yearly bronze plan',
      billingCycles: [
        BillingCycle(
            pricingScheme: PricingScheme(
              fixedPrice: Money(currencyCode: 'GBP', value: '5'),
            ),
            frequency: Frequency(
              intervalUnit: IntervalUnit.month,
              intervalCount: 1,
            ),
            tenureType: TenureType.regular,
            sequence: 1)
      ],
      //P-6K666766XF6762900MMFWPII, P-4WV13929LY488164HMMFWPXA, P-51A176327L565063LMMFWQNA
      paymentPreferences: PaymentPreferences(
        autoBillOutstanding: true,
        setupFee: Money(currencyCode: 'GBP', value: '1.00'),
        setupFeeFailureAction: SetupFeeFailureAction.cancel,
        paymentFailureThreshold: 2,
      ),
    );
    billingPlan = await subscriptionsApi.createPlan(planRequest);
    print(billingPlan);
  } on ApiException catch (e) {
    print(e);
  }

  // // Update plan
  // try {
  //   await subscriptionsApi.updatePlan(
  //     'P-6KG67732XY2608640MFGL3RY',
  //     [
  //       Patch(
  //           op: PatchOperation.replace,
  //           path: '/description',
  //           value: 'Test description')
  //     ],
  //   );
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Show plan details
  // try {
  //   var billingPlan =
  //       await subscriptionsApi.showPlanDetails('P-6KG67732XY2608640MFGL3RY');
  //   print(billingPlan);
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Activate plan
  // try {
  //   await subscriptionsApi.activatePlan('P-6KG67732XY2608640MFGL3RY');
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Deactivate plan
  // try {
  //   await subscriptionsApi.deactivatePlan('P-6KG67732XY2608640MFGL3RY');
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Update plan pricing
  // try {
  //   await subscriptionsApi.updatePlanPricing(
  //       'P-6KG67732XY2608640MFGL3RY',
  //       PricingSchemesUpdateRequest([
  //         PricingSchemeUpdateRequest(
  //             billingCycleSequence: 1,
  //             pricingScheme: PricingScheme(
  //               fixedPrice: Money(currencyCode: 'GBP', value: '5.0'),
  //             ))
  //       ]));
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // Subscriptions
  // Create subscription
  late Subscription subscription;
  try {
    var createSubscriptionRequest = SubscriptionRequest(
      plan: billingPlan,
      planId: billingPlan.id,
      applicationContext: ApplicationContext(
        returnUrl: 'https://google.com',
        cancelUrl: 'https://com.gulfterminal.dreams',
      ),
      customId: 'custom_id',
    );
    subscription =
        await subscriptionsApi.createSubscription(createSubscriptionRequest);
    // log("${subscription.links?.firstWhere((element) => element.rel.contains('approve')).href}");
    final link =
        ("${subscription.links?.firstWhere((element) => element.rel.contains('approve')).href}");
    _controller?.loadUrl(link);
    // launchUrl(Uri.parse(link));

    print(subscription);
  } on ApiException catch (e) {
    print(e);
  }

  // // Update subscription
  // try {
  //   await subscriptionsApi.updateSubscription('I-1WSNAWATBCXP', [
  //     Patch(
  //         op: PatchOperation.add,
  //         path: '/custom_id',
  //         value: 'updated_custom_id')
  //   ]);
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // Show subscription details
  // try {
  //   var sub = await subscriptionsApi.showSubscriptionDetails(subscription.id);
  //   log("$sub");
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // Activate subscription
  // try {
  //   final subscriptionActivate =
  //       subscriptionsApi.activateSubscription(subscription.id, 'why not');
  //   log("$subscriptionActivate");
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Cancel subscription
  // try {
  //   await subscriptionsApi.cancelSubscription(
  //       'I-93KN27174NGR', 'No longer needed');
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Capture authorized payment on subscription
  // try {
  //   var request = SubscriptionCaptureRequest(
  //       note: 'Outstanding balance',
  //       amount: Money(currencyCode: 'GBP', value: '5.00'));

  //   var response = await subscriptionsApi
  //       .captureAuthorizedPaymentOnSubscription('I-1WSNAWATBCXP', request);
  //   print(response);
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Revise plan or quantity of subscription
  // try {
  //   var request = SubscriptionReviseRequest(
  //       planId: 'P-9DR273747C8107746MFGHYKY',
  //       shippingAmount: Money(currencyCode: 'USD', value: '2.0'));

  //   var response =
  //       await subscriptionsApi.reviseSubscription('I-1WSNAWATBCXP', request);
  //   print(response);
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // Suspend subscription
  // try {
  //   var request = Reason('Out of stock');
  //   await subscriptionsApi.suspendSubscription('I-1WSNAWATBCXP', request);
  // } on ApiException catch (e) {
  //   print(e);
  // }

  // // List transactions for subscription
  // try {
  //   var response = await subscriptionsApi.listTransactions('I-1WSNAWATBCXP',
  //       '2021-09-01T07:50:20.940Z', '2021-09-29T07:50:20.940Z');
  //   print(response);
  // } on ApiException catch (e) {
  //   print(e);
  // }
}

Future<void> webhookExamples(PayPalHttpClient payPalHttpClient) async {
  var webhooksApi = WebhooksApi(payPalHttpClient);

  // List webhooks
  try {
    var webhooksList = await webhooksApi.listWebhooks();
    print(webhooksList);
  } on ApiException catch (e) {
    print(e);
  }

  // Create webhook
  try {
    var webhook =
        Webhook(url: 'https://api.test.com/paypal_callback', eventTypes: [
      EventType(name: 'BILLING.SUBSCRIPTION.CREATED'),
      EventType(name: 'BILLING.SUBSCRIPTION.CANCELLED'),
    ]);

    webhook = await webhooksApi.createWebhook(webhook);
    print(webhook);
  } on ApiException catch (e) {
    print(e);
  }

  // Delete webhook
  try {
    await webhooksApi.deleteWebhook('1HG80537L4140544T');
  } on ApiException catch (e) {
    print(e);
  }

  // Update webhook
  try {
    await webhooksApi.updateWebhook('5B760822JX046254S', [
      Patch(
          op: PatchOperation.replace,
          path: '/url',
          value: 'https://api.test.com/paypal_callback_new'),
    ]);
  } on ApiException catch (e) {
    print(e);
  }

  // Show webhook details
  try {
    var webhook = await webhooksApi.showWebhookDetails('7BS56736HU608525B');
    print(webhook);
  } on ApiException catch (e) {
    print(e);
  }

  // List event types for webhook
  try {
    var eventTypesList =
        await webhooksApi.listEventSubscriptionsForWebhook('7BS56736HU608525B');
    print(eventTypesList);
  } on ApiException catch (e) {
    print(e);
  }

  // List available events
  try {
    var eventTypesList = await webhooksApi.listAvailableEvents();
    print(eventTypesList);
  } on ApiException catch (e) {
    print(e);
  }
}

class LoadSubButton extends StatefulWidget {
  final Function() pay;
  const LoadSubButton({
    Key? key,
    required this.pay,
  }) : super(key: key);

  @override
  State<LoadSubButton> createState() => _LoadSubButtonState();
}

class _LoadSubButtonState extends State<LoadSubButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ;
    return WebView(
      onWebViewCreated: (controller) async {
        _controller = controller;
        await widget.pay();
        Future.delayed(10.s, () => setState(() {}));
      },
      initialUrl: 'about:blank',
      onPageFinished: (s) {
        log("$s");
        if (s.contains("google.com"))
          // _controller?.goBack();
          context.pop(s);
      },
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: {
        JavascriptChannel(
          name: 'onApprove',
          onMessageReceived: (JavascriptMessage message) {
            log(message.message);
          },
        )
      },
    );
  }
}
