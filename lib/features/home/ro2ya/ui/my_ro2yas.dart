import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyRo2yas extends StatelessWidget {
  const MyRo2yas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: '',
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Ro2yaCard();
        },
      ),
    );
  }
}

class Ro2yaCard extends StatelessWidget {
  const Ro2yaCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "رأيت كأني أطير وأتحدث لغة غريبة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Image.asset(R.ASSETS_IMAGES_CLOCK_PNG),
                      Text(
                        'الأربعاء , 5 يوليو 2022',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 16.h,bottom:  16.h, start: 16.w),
                        child: Image.asset(R.ASSETS_IMAGES_WAITING_PNG),
                      ),
                      Text(
                        "في إنتظار رد المعبر",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(R.ASSETS_IMAGES_TEST_PROFILE_PNG)),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "معمر المطيري",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
