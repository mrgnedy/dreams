import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/ui/ta3beer_request.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoaberenListScreen extends StatelessWidget {
  const MoaberenListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        title: LocaleKeys.mo3aberenList.tr(),
        body: ListView.builder(
          itemCount: 20,
          // itemExtent: 190.h,
          itemBuilder: (context, index) => Mo3aberCard(),
        ));
  }
}

class Mo3aberCard extends StatelessWidget {
  const Mo3aberCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 0),
      child: Container(
        // height: 190.h,
        width: 350.w,
        decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Column(
                children: [
                  const MoaberDetailsCard(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientButton(
                        onTap: () => const TaabeerRequest().push(context),
                        title: "طلب تعبير رؤيا"),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class MoaberDetailsCard extends StatelessWidget {
  const MoaberDetailsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Image.asset(R.ASSETS_IMAGES_TEST_PROFILE_PNG)),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'معمر المطيري',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0.h),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(R.ASSETS_IMAGES_CUP_PNG),
                        Text(
                          'خبرة 5 أعوام',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.green,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 20.0.w),
                      child: Row(
                        children: [
                          Image.asset(R.ASSETS_IMAGES_FLASH_PNG),
                          Text(
                            'خبرة 5 أعوام',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0.h),
                child: Text(
                  "تفسير الأحلام وما توفيقي إلا بالله",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
