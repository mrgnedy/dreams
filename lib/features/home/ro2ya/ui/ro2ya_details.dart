import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/ui/commonWidgets/moaber_sepcs.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoyaDetailsScreen extends StatelessWidget {
  const RoyaDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'رأيت كأني أطير وأتحدث لغة غريبة',
      body: SingleChildScrollView(
        child: Padding(
          padding:   EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              RequestInfo(),
              Moaber(),
              RoyaDetails(),
              Tafseer(),
              Estedlal()
            ],
          ),
        ),
      ),
    );
  }
}

class Estedlal extends StatelessWidget {
  const Estedlal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TextWithTitle('وجه الإستدلال',
        'هل حلمتَ يوماً بأنك وجدتَ مالاً وفكرت فيما قد تكون دلالة رؤية الفلوس بالمنام؟ هناك دلالات كثيرة لرؤية المال في المنام وتختلف باختلاف تفسيرات المفسرين، وباختلاف حالة الرائي، وفي هذا المقال سنقدم لكم بعض أشهر تفسيرات رؤية المال في المنام');
  }
}

class Tafseer extends StatelessWidget {
  const Tafseer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TextWithTitle('التعبير / التفسير',
        ' يقال أن عثورك على نقود في الحلم يشير إلى أنك ستواجه.مشاكل بسيطة، يعقبها كثير من الأفراح وتبدل الحال وإذا دفعت نقوداً في الحلم فهذا فأل سيئ، أما إذا وجدت.عملة ذهبية فهذا ينبئ بالخير الكثير والمسرات إذا خسرت المال في المنام فهذا ينبئ بأنك سوف تواجه بعض المنغصات في محيط الأسرة، كما أن أعمالك ستشهد.بعض العثرات أما إذا ما قمت بعد النقود في المنام ووجدتها ناقصة فهذا.دلالة على أنك ستدفع مالاً تحزن عليه إذا حلمت أنك سرقت نقوداً فهذا ينبئ بأنك في خطر.وعليك أن تزن خطواتك وتحذر');
  }
}

class RoyaDetails extends StatelessWidget {
  const RoyaDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TextWithTitle('تفاصيل الرؤيا',
        'هل حلمتَ يوماً بأنك وجدتَ مالاً وفكرت فيما قد تكون دلالة رؤية الفلوس بالمنام؟ هناك دلالات كثيرة لرؤية المال في المنام وتختلف باختلاف تفسيرات المفسرين، وباختلاف حالة الرائي، وفي هذا المقال سنقدم لكم بعض أشهر تفسيرات رؤية المال في المنام');
  }
}

class _TextWithTitle extends StatelessWidget {
  final String title;
  final String txt;
  const _TextWithTitle(
    this.title,
    this.txt, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:   EdgeInsets.symmetric(vertical:24.h),
          child: _SubTitle(title),
        ),
        Text(
          txt,
          style: TextStyle(fontSize: 15.sp),
        ),
        Padding(
          padding: EdgeInsets.only( top: 36.h),
          child: const Divider(),
        ),
      ],
    );
  }
}

class Moaber extends StatelessWidget {
  const Moaber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h),
          child: const _SubTitle("معلومات الطلب"),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(child: Image.asset(R.ASSETS_IMAGES_TEST_PROFILE_PNG)),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معمر المطيري',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    // const MoaberSpecs()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String txt;
  const _SubTitle(
    this.txt, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RequestInfo extends StatelessWidget {
  const RequestInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h),
          child: const _SubTitle("معلومات الطلب"),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(R.ASSETS_IMAGES_TIME_BLUE_PNG),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 8.0.w),
                          child: Text(
                            'وقت الطلب',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'الأربعاء , 5 يوليو 2022',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(R.ASSETS_IMAGES_WAITING_PNG),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 8.0.w),
                          child: Text(
                            'حالة الطلب',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'تم رد المعبر',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
