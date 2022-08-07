// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dreams/features/account/ui/subscriptions.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuyNowScreen extends StatelessWidget {
  final CardItem pkg;
  const BuyNowScreen({
    Key? key,
    required this.pkg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(

      isAppBarFixed: true,
      gradientAreaHeight: 250.h,
      body: Column(
        children: [
          SizedBox(
            height: 0.05.sh,
          ),
          Text(
            "الشراء الآن",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          Padding(
            padding:   EdgeInsets.only(top:16.0.h),
            child: SubscriptionCard(
              isBuy: true,
                subscriptionPkg:
                    pkg),
          ),
        ],
      ),
    );
  }
}
