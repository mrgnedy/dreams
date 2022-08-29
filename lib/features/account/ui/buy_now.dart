// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/data/models/packages_model.dart';
import 'package:dreams/features/account/state/subscription_cubit_pay.dart';
import 'package:dreams/features/account/state/subscriptions_cubit.dart';
import 'package:dreams/features/account/ui/paymentMethods/paypal_webview.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/helperWidgets/app_loader.dart';

import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/dialogs.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/account/ui/subscriptions.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/app_radio_group.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paypal_sdk/subscriptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/subscription_state.dart';

class BuyNowScreen extends StatelessWidget {
  final CardItem pkg;
  const BuyNowScreen({
    Key? key,
    required this.pkg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<SubscriptionPayCubit>(context);
    log("PKG: ${cubit.state.selectedPlan}");
    return MainScaffold(
        isAppBarFixed: true,
        gradientAreaHeight: 180,
        body: BlocConsumer<SubscriptionPayCubit, SubscriptionStateModel>(
          listener: (context, state) async {
            // TODO: implement listener
            if (state.state is SuccessResult) {
              final successData = state.state.getSuccessData();
              // User subscription
              if (successData is AuthData) {
                await AppAlertDialog.show(
                    context, LocaleKeys.subscribedSuccessfully.tr());

                context.pop();
                context.pop();
              }
              // Show subscription details
              if (successData is SubscriptionStatus) {
                final subStatus = successData;
                log('sub status: $subStatus');
                if (subStatus == SubscriptionStatus.active ||
                    subStatus == SubscriptionStatus.approved) {
                  log("Yay!");
                  cubit.subscribe();
                }
              }
              // Create subscription
              if (successData is Subscription) {
                final subscription = successData;
                final link =
                    "${subscription.links?.firstWhere((element) => element.rel.contains('approve')).href}";

                final result = await PaypalWebview(
                  url: link,
                  onSubscribe: () async {
                    final pref = await SharedPreferences.getInstance();
                    pref.setString('subId', successData.id);
                  },
                ).push(context);
                await cubit.getSubscriptionDetails(subscription.id);
                log("Payment result: $result");
              }
              //   Fluttertoast.showToast(
              //       msg: LocaleKeys.subscribedSuccessfully.tr());
              //   di<AuthCubit>().updateState(successData);
              //   context.pop();
              //   context.pop();
            }
            if (state.state is ErrorResult) {
              AppAlertDialog.show(context, "${state.state.getErrorMessage()}",
                  isSuccess: false);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.05.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.buyNow.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0.h),
                  child: SubscriptionCard(
                    isBuy: true,
                    subscriptionPkg: pkg,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24.h, bottom: 0.h),
                        child: Text(
                          LocaleKeys.subscribePkg.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.h, bottom: 24.h),
                        child: Text(
                          LocaleKeys.choosePaymentMethod.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PaymentTypes(),
                ConfirmPaymentMethod(cubit: cubit, pkg: pkg),
              ],
            );
          },
        ));
  }
}

class ConfirmPaymentMethod extends StatelessWidget {
  const ConfirmPaymentMethod({
    Key? key,
    required this.cubit,
    required this.pkg,
  }) : super(key: key);

  final SubscriptionPayCubit cubit;
  final CardItem pkg;

  @override
  Widget build(BuildContext context) {
    final state = cubit.state;
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: GradientButton(
        state: state.state,
        onTap: () {
          if (isGeust()) {
            return AppAlertDialog.show(
              context,
              LocaleKeys.pleaseLoginFirst.tr(),
              isSuccess: false,
            );
          }
          if (state.selectedMethod == null) {
            return Fluttertoast.showToast(msg: "Please select payment method");
          }
          if (state.selectedMethod!.contains('cash')) {
            return cubit.subscribe();
          }
          final s = cubit;
          s.makeSubscription(pkg.id);
        },
        title: LocaleKeys.confirmPayment.tr(),
      ),
    );
  }
}

class PaymentTypes extends StatefulWidget {
  PaymentTypes({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentTypes> createState() => _PaymentTypesState();
}

class _PaymentTypesState extends State<PaymentTypes> {
  final paymentTypes = [
    "Paypal",
    "Card - Debit ",
    "Transfer and send transfer details",
    "Payoneer",
  ];
  final paymentSubtitle = [
    "",
    "",
    "Admin will activate",
    "",
  ];
  int? groupValue;
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<SubscriptionPayCubit>(context);
    final payments = cubit.state.paymentMethods;
    if (payments == null) {
      return const AppLoader();
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: payments.toMap().length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = index;
                });
                cubit.updatePaymentMethod(
                  payments.toMap().entries.elementAt(index).key,
                );
              },
              child: PaymentTypeCard(
                key: Key("$index"),
                type: payments.toMap().entries.elementAt(index).value,
                value: index,
                subtitle: paymentSubtitle[index],
                groupValue: groupValue,
              ),
            );
          },
        ),
      );
    }
  }
}

class PaymentTypeCard extends StatelessWidget {
  final int value;
  final int? groupValue;
  final String type;
  final String subtitle;
  const PaymentTypeCard({
    Key? key,
    required this.value,
    required this.subtitle,
    required this.type,
    required this.groupValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.h).copyWith(top: 0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              groupValue == value
                  ? Image.asset(R.ASSETS_IMAGES_CHECK_BLUE_PNG)
                  : Container(
                      height: 30.h,
                      width: 30.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blue),
                        shape: BoxShape.circle,
                      ),
                    ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Text(
                        subtitle.isEmpty
                            ? LocaleKeys.onlinePayment.tr()
                            : subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(R.ASSETS_IMAGES_VISA_COLOR_PNG),
            ],
          ),
        ),
      ),
    );
  }
}
