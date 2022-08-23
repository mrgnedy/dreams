import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/app_radio_group.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLanguageScreen extends StatelessWidget {
  AppLanguageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int groupValue = context.appLocale.languageCode == 'ar' ? 0 : 1;
    return MainScaffold(
      title: LocaleKeys.appLanguage.tr(),
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Text(
                LocaleKeys.chooseAppLanguage.tr(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
              ),
            ),
            RadioListTile(
              value: 0,
              groupValue: groupValue,
              onChanged: (b) {
                context.updateLocale(const Locale('ar'));
              },
              title: const Text("العربية"),
              secondary: Image.asset(
                R.ASSETS_IMAGES_SAUDI_ARABIA_PNG,
                height: 60.r,
              ),
            ),
            const Divider(),
            RadioListTile(
              value: 1,
              groupValue: groupValue,
              onChanged: (b) {
                context.updateLocale(const Locale('en'));
              },
              title: const Text("English"),
              secondary: Image.asset(
                R.ASSETS_IMAGES_UNITED_KINGDOM_PNG,
                height: 60.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
