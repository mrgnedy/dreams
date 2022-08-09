// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/account/ui/subscriptions.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/app_radio_group.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 0.05.sh,
          ),
          Text(
            "الشراء الآن",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0.h),
            child: SubscriptionCard(
              isBuy: true,
              subscriptionPkg: pkg,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.h, bottom: 0.h),
            child: Text(
              'الإشتراك في الباقة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.h, bottom: 24.h),
            child: Text(
              "قم بإختيار طريقة الدفع المناسبة لاتمام الاشتراك",
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
              ),
            ),
          ),
          PaymentTypes()
        ],
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
  int? groupValue;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                groupValue = index;
              });
            },
            child: PaymentTypeCard(
              key: Key("$index"),
              value: index,
              groupValue: groupValue,
            ),
          );
        },
      ),
    );
  }
}

class PaymentTypeCard extends StatelessWidget {
  final int value;
  final int? groupValue;
  const PaymentTypeCard({
    Key? key,
    required this.value,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الدفع الإلكتروني",
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    "Visa / Master باستخدام البطاقات البنكية",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Image.asset(R.ASSETS_IMAGES_VISA_COLOR_PNG),
            ],
          ),
        ),
      ),
    );
  }
}
