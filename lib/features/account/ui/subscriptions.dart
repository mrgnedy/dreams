import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/account/ui/buy_now.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SubscriptionSelector { gold, silver, bronze }

extension SubscriptionExt on SubscriptionSelector {
  CardItem getData() {
    switch (this) {
      case SubscriptionSelector.gold:
        return const CardItem(
            name: "باقة ذهبية",
            icon: R.ASSETS_IMAGES_GOLD_PKG_PNG,
            subTitle: R.ASSETS_IMAGES_CHECK_OUTLINE_YELLOW_PNG,
            color: Color.fromRGBO(231, 201, 11, 0.16),
            args: [
              "تفسير 5 رؤى صالح لمدة عام",
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
              "تفسير 3 رؤى صالح لمدة عام",
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
            "تفسير رؤىة واحدة صالح لمدة عام",
            "إستفسار بعد تأول كل رؤى",
            "الرد خلال يوم"
          ],
        );
    }
  }
}

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "الباقات والاشتراكات",
      body: ListView.builder(
        itemCount: SubscriptionSelector.values.length,
        itemBuilder: (context, index) => SubscriptionCard(
          subscriptionPkg: SubscriptionSelector.values[index].getData(),
        ),
      ),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Image.asset(pkg.icon!)),
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
                                  fontWeight: FontWeight.bold, fontSize: 16.sp),
                            ),
                          ),
                          ...pkg.args!.map((e) => Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0.h),
                                    child: Image.asset(pkg.subTitle!),
                                  ),
                                  Text(
                                    '$e',
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
                    child: GradientButton(
                        onTap: () => BuyNowScreen(
                              pkg: subscriptionPkg,
                            ).push(context),
                        title: "الشراء الآن"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
