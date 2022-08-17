// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/data/models/subscription_model.dart';
import 'package:dreams/helperWidgets/app_loader.dart';
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

enum SubscriptionSelector { gold, silver, bronze }

extension SubscriptionExt on SubscriptionSelector {
  CardItem updateData(Package pkg) {
    final data = getData();
    var args = data.args!.map((e) => '$e').toList();
    return data.copyWith(
      args: args
        ..first = args.first
            .replaceFirst('{years}', "${(pkg.months / 12).ceil()}")
            .replaceFirst('{count}', "${pkg.dreams_count}"),
      name: pkg.name,
      icon: pkg.image,
      id: pkg.id,
    );
  }

  CardItem getData() {
    switch (this) {
      case SubscriptionSelector.gold:
        return const CardItem(
            name: "باقة ذهبية",
            icon: R.ASSETS_IMAGES_GOLD_PKG_PNG,
            subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_YELLOW_PNG,
            color: Color.fromRGBO(231, 201, 11, 0.16),
            args: [
              "تفسير {count} رؤى صالح لمدة {years} عام",
              "إستفسار بعد تأول كل رؤى",
              "الرد خلال يوم"
            ]);
      case SubscriptionSelector.silver:
        return const CardItem(
            name: "باقة فضية",
            icon: R.ASSETS_IMAGES_SILVER_PKG_PNG,
            subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_BLUE_PNG,
            color: Color.fromRGBO(108, 160, 171, 0.16),
            args: [
              "تفسير {count} رؤى صالح لمدة {years} عام",
              "إستفسار بعد تأول كل رؤى",
              "الرد خلال يوم"
            ]);
      case SubscriptionSelector.bronze:
        return const CardItem(
          name: "باقة برةنزية",
          icon: R.ASSETS_IMAGES_BRONZE_PKG_PNG,
          subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_GREEN_PNG,
          color: Color.fromRGBO(137, 171, 108, 0.16),
          args: [
            "تفسير {count} رؤى صالح لمدة {years} عام",
            "إستفسار بعد تأول كل رؤى",
            "الرد خلال يوم"
          ],
        );
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
    return MainScaffold(
      title: LocaleKeys.packagesSubscriptions.tr(),
      body: Builder(builder: (context) {
        final cubit = BlocProvider.of<SubscriptionCubit>(context);
        return BlocBuilder<SubscriptionCubit, PackagesModel>(
          bloc: cubit..getPackages(),
          builder: (context, state) {
            if (state.state is LoadingResult && state.data.isEmpty) {
              return const AppLoader();
            }
            return ListView.builder(
              itemCount: SubscriptionSelector.values.length,
              itemBuilder: (context, index) {
                final pkgData = state.data[index];
                return SubscriptionCard(
                  subscriptionPkg:
                      SubscriptionSelector.values[index].updateData(pkgData),
                );
              },
            );
          },
        );
      }),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final CardItem subscriptionPkg;
  final bool isBuy;
  const SubscriptionCard({
    Key? key,
    required this.subscriptionPkg,
    this.isBuy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pkg = subscriptionPkg;
    return Padding(
      padding: EdgeInsets.all(16.h).copyWith(bottom: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: isBuy ? Colors.white : Colors.transparent,
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
                  if (!isBuy)
                    Padding(
                      padding: EdgeInsets.all(16.0.h),
                      child: Builder(builder: (context) {
                        return GradientButton(
                            onTap: () {
                              BlocProvider.of<SubscriptionCubit>(context)
                                  .selectPackage(subscriptionPkg.id!);
                              return BlocProvider.value(
                                  value: BlocProvider.of<SubscriptionCubit>(
                                      context),
                                  child: BuyNowScreen(
                                    pkg: subscriptionPkg,
                                  )).push(context);
                            },
                            title: LocaleKeys.buyNow.tr());
                      }),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
