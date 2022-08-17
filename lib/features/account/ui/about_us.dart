import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: LocaleKeys.aboutUs.tr(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24.h),
              child: CircleAvatar(
                radius: 80.r,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Image.asset(
                    R.ASSETS_IMAGES_LOGO_PNG,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: const Text(
                  ' يقال أن عثورك على نقود في الحلم يشير إلى أنك ستواجه.مشاكل بسيطة، يعقبها كثير من الأفراح وتبدل الحال وإذا دفعت نقوداً في الحلم فهذا فأل سيئ، أما إذا وجدت.عملة ذهبية فهذا ينبئ بالخير الكثير والمسرات إذا خسرت المال في المنام فهذا ينبئ بأنك سوف تواجه بعض'),
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: const Text(
                  ' يقال أن عثورك على نقود في الحلم يشير إلى أنك ستواجه.مشاكل بسيطة، يعقبها كثير من الأفراح وتبدل الحال وإذا دفعت نقوداً في الحلم فهذا فأل سيئ، أما إذا وجدت.عملة ذهبية فهذا ينبئ بالخير الكثير والمسرات إذا خسرت المال في المنام فهذا ينبئ بأنك سوف تواجه بعض'),
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: const Text(
                  ' يقال أن عثورك على نقود في الحلم يشير إلى أنك ستواجه.مشاكل بسيطة، يعقبها كثير من الأفراح وتبدل الحال وإذا دفعت نقوداً في الحلم فهذا فأل سيئ، أما إذا وجدت.عملة ذهبية فهذا ينبئ بالخير الكثير والمسرات إذا خسرت المال في المنام فهذا ينبئ بأنك سوف تواجه بعض'),
            ),
          ],
        ),
      ),
    );
  }
}
