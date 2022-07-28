import 'package:dreams/helperWidgets/app_checkbox.dart';
import 'package:dreams/helperWidgets/app_radio_group.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/ui/mo3aberen_list.dart';
import 'package:dreams/helperWidgets/app_tab_bar.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';

class TaabeerRequest extends StatelessWidget {
  const TaabeerRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      // title: "طلب تعبير رؤيا",
      isAppBarFixed: true,
      gradientAreaHeight: 190,
      body: Padding(
        padding: EdgeInsets.only(top: 48.0.h),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: AppBackButton(isAppBarFixed: false)),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "طلب تعبير رؤيا",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0.w).copyWith(top: 26.h),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.blueGrey,
                    borderRadius: BorderRadius.circular(16)),
                child: const MoaberDetailsCard(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 0.9.sw,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50.h,
                          child: const AppTabBar(
                            tabs: [
                              Text('محتوى الرؤية'),
                              Text('تسجيل صوتي'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0.h),
                          child: AppTextFormField(
                            hint: " ..p. موضوع الرؤيا",
                            onChanged: (s) {},
                          ),
                        ),
                        const AppRadioGroupWithTitle(
                          items: ["لنفسي", "لغيرى"],
                          title: " هل شاهدت الرؤيا بنفسك أم تسأل لغيرك ؟",
                        ),
                        const AppRadioGroupWithTitle(
                          items: ["متزوج", "أعزب", "منفصل"],
                          title: "الحالة الإجتماعية",
                        ),
                        const AppRadioGroupWithTitle(
                          items: ["نعم", "لا"],
                          title: "هل يعاني الرائي من مرض بدني أو روحي ؟",
                        ),
                        Padding(
                          padding:   EdgeInsets.symmetric(vertical:16.0.h),
                          child: Text(
                            "ما يشغل الرائي قبل الرؤيا ؟",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        AppTextFormField(
                          hint: ' ... أكتب تفاصيل',
                          onChanged: (s) {},
                          maxLines: 3,
                        ),
                        AppTextFormField(
                          hint: "تاريخ الرؤيا",
                          textType: TextType.date,
                          onChanged: (s) {},
                        ),
                        AppTextFormField(
                          hint: "الوظيفة / طبيعة العمل",
                          onChanged: (s) {},
                        ),
                        Padding(
                          padding:   EdgeInsets.symmetric(vertical:12.0.h),
                          child: Text(
                            "معلومات إضافية عن حالة الرائي",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        AppTextFormField(
                          hint: ' ... أكتب تفاصيل',
                          onChanged: (s) {},
                          maxLines: 3,
                        ),
                        Padding(
                          padding:   EdgeInsets.symmetric(vertical:8.0.h),
                          child: const AppRadioGroupWithTitle(
                            items: ['نعم', "لا"],
                            title: "هل الرؤية بعد إستخارة أو حدث مؤثر معين ؟",
                          ),
                        ),
                        Text(
                          "تفاصيل الرؤيا",
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0.h),
                          child: AppTextFormField(
                            hint: ' ... أكتب تفاصيل',
                            onChanged: (s) {},
                            maxLines: 3,
                          ),
                        ),
                        Padding(
                          padding:   EdgeInsets.symmetric(vertical:12.0.h),
                          child: const AppCheckBox(
                              text: 'أريد إظهار الرؤيا للمستخدمين',
                              isChecked: true),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: GradientButton(
                              onTap: () {}, title: 'إرسال الطلب'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
