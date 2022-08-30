// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/data/models/subscription_model.dart';
import 'package:dreams/features/account/data/models/subscription_state.dart';
import 'package:dreams/features/account/state/subscription_cubit_pay.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/helperWidgets/app_loader.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/account/data/models/packages_model.dart';
import 'package:dreams/features/account/state/subscriptions_cubit.dart';
import 'package:dreams/features/account/ui/buy_now.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:paypal_sdk/subscriptions.dart';

enum SubscriptionSelector {
  diamond,
  gold,
  silver,
}

extension SubscriptionExt on SubscriptionSelector {
  CardItem updateData(Plan pkg) {
    final data = getData();
    var args = data.args!.map((e) => '$e').toList();
    // return data;
    final infoList = pkg.description!.split(', ');
    final duration = infoList[0];
    final count = infoList[1];
    final image = infoList[2];

    return data.copyWith(
      args: args
        ..first = args.first
            .replaceFirst('{years}', duration)
            .replaceFirst('{count}', count),
      name: pkg.name.toLowerCase().tr(),
      icon: image,
      id: pkg.id,
    );
  }

  CardItem getData() {
    switch (this) {
      case SubscriptionSelector.diamond:
        return const CardItem(
          type: 1,
          id: "P-9SW698515M541033HMMG5TJY",
          name: "باقة ماسية",
          icon: R.ASSETS_IMAGES_BRONZE_PKG_PNG,
          subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_GREEN_PNG,
          color: Color.fromRGBO(137, 171, 108, 0.16),
          args: [
            "تفسير {count} رؤى صالح لمدة {years} شهر",
            "إستفسار بعد تأول كل رؤى",
            "الرد خلال يوم"
          ],
        );
      case SubscriptionSelector.gold:
        return const CardItem(
          type: 2,
          id: "P-53Y48101S1563192CMMG5RCY",
          name: "باقة ذهبية",
          icon: R.ASSETS_IMAGES_GOLD_PKG_PNG,
          subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_YELLOW_PNG,
          color: Color.fromRGBO(231, 201, 11, 0.16),
          args: [
            "تفسير {count} رؤى صالح لمدة {years} شهر",
            "إستفسار بعد تأول كل رؤى",
            "الرد خلال يوم"
          ],
        );
      case SubscriptionSelector.silver:
        return const CardItem(
          type: 3,
          id: "P-6K666766XF6762900MMFWPII",
          name: "باقة فضية",
          icon: R.ASSETS_IMAGES_SILVER_PKG_PNG,
          subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_BLUE_PNG,
          color: Color.fromRGBO(108, 160, 171, 0.16),
          args: [
            "تفسير {count} رؤى صالح لمدة {years} شهر",
            "إستفسار بعد تأول كل رؤى",
            "الرد خلال يوم"
          ],
        );
      // case SubscriptionSelector.bronze:
      //   return const CardItem(
      //     id: "P-9UW14655H8056935GMMFU2JA",
      //     name: "باقة برةنزية",
      //     icon: R.ASSETS_IMAGES_BRONZE_PKG_PNG,
      //     subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_GREEN_PNG,
      //     color: Color.fromRGBO(137, 171, 108, 0.16),
      //     args: [
      //       "تفسير {count} رؤى صالح لمدة {years} عام",
      //       "إستفسار بعد تأول كل رؤى",
      //       "الرد خلال يوم"
      //     ],
      //   );
    }
  }
}

class SubscriptionsScreen extends StatelessWidget {
  // final SubscriptionCubit cubit;
  const SubscriptionsScreen({
    Key? key,
    // required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = di<AuthCubit>().state;
    return MainScaffold(
      title: LocaleKeys.packagesSubscriptions.tr(),
      body: Builder(
        builder: (context) {
          final cubit = BlocProvider.of<SubscriptionPayCubit>(context);
          return BlocBuilder<SubscriptionPayCubit, SubscriptionStateModel>(
            bloc: cubit,
            builder: (context, state) {
              if (state.state is LoadingResult &&
                  state.planCollection == null) {
                return const AppLoader();
              }
              return Column(
                children: [
                  if (user.subscriptionData != null)
                    // final planIndex = user.subscriptionData!.package.id - 1;
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24.h).copyWith(bottom: 0),
                          child: Text(
                            "الباقة الحالية",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SubscriptionCard(
                          subscriptionPkg: SubscriptionSelector
                              .values[user.subscriptionData!.package.id - 1]
                              .updateData(state.planCollection![
                                  user.subscriptionData!.package.id - 1]),
                          tailWidget: const SizedBox.shrink(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.h).copyWith(bottom: 0),
                          child: Text(
                            "الباقات",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: SubscriptionSelector.values.length,
                      itemBuilder: (context, index) {
                        final pkgData = state.planCollection!.toList()[index];
                        return SubscriptionCard(
                          subscriptionPkg: SubscriptionSelector.values[index]
                              .updateData(pkgData),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final CardItem subscriptionPkg;
  final Widget? tailWidget;
  const SubscriptionCard({
    Key? key,
    required this.subscriptionPkg,
    this.tailWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pkg = subscriptionPkg;
    return Padding(
      padding: EdgeInsets.all(16.h).copyWith(bottom: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: tailWidget != null ? Colors.white : Colors.transparent,
          child: Container(
            color: pkg.color,
            child: Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Image.network(
                        pkg.icon!,
                        height: 80.h,
                      )),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0.h),
                              child: Text(
                                pkg.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ),
                            ...pkg.args!.map((e) => Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0.h),
                                      child: Image.asset(pkg.subTitle!),
                                    ),
                                    Text(
                                      '${e.trim()}',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (tailWidget == null)
                    Padding(
                      padding: EdgeInsets.all(16.0.h),
                      child: Builder(builder: (context) {
                        return GradientButton(
                            onTap: () {
                              BlocProvider.of<SubscriptionPayCubit>(context)
                                  .selectPlan(subscriptionPkg.id!);
                              BlocProvider.of<SubscriptionPayCubit>(context)
                                  .selectPkg(pkg);
                              BlocProvider.of<SubscriptionPayCubit>(context)
                                  .getPaymentMethods();
                              return BlocProvider.value(
                                  value: BlocProvider.of<SubscriptionPayCubit>(
                                      context),
                                  child: BuyNowScreen(
                                    pkg: subscriptionPkg,
                                  )).push(context);
                            },
                            title: LocaleKeys.buyNow.tr());
                      }),
                    )
                  else
                    tailWidget!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
