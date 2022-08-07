import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ProfileFieldSelector {
  name,
  mail,
  phone,
  country,
  city,
  birthdate,
  job,
  gender
}

extension ProfileExt on ProfileFieldSelector {
  CardItem getData() {
    switch (this) {
      case ProfileFieldSelector.name:
        return CardItem(
            name: LocaleKeys.name.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_USER_PNG,
            onPressed: (s) => log('$s'));
      case ProfileFieldSelector.mail:
        return CardItem(
            name: LocaleKeys.phone.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_MAIL_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.phone:
        return CardItem(
            name: LocaleKeys.email.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_MAIL_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.country:
        return CardItem(
            name: LocaleKeys.country.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_USER_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.city:
        return CardItem(
            name: LocaleKeys.city.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_USER_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.birthdate:
        return CardItem(
            name: LocaleKeys.birthdate.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_USER_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.job:
        return CardItem(
            name: LocaleKeys.yourJob.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_USER_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.gender:
        return CardItem(
            name: LocaleKeys.gender.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_USER_PNG,
            onPressed: (s) => log('$s'));
    }
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = di<AuthCubit>().state;
    return MainScaffold(
      title: "تعديل المعلومات الشخصية",
      body: Container(
        width: 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.0.h),
                child: Container(
                  child: ClipOval(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 80.r,
                      child: userData.image!.isEmpty
                          ? Image.asset(R.ASSETS_IMAGES_TEST_PROFILE_PNG)
                          : Image.network(
                              userData.image!,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: AlignmentDirectional.bottomStart,
                      image: AssetImage(
                        R.ASSETS_IMAGES_CAMERA_PNG,
                      ),
                    ),
                  ),
                ),
              ),
              ...ProfileFieldSelector.values.map((e) {
                final data = e.getData();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name!,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    AppTextFormField(
                      hint: data.subTitle!,
                      onChanged: data.onPressed as Function(String),
                      textType: data.type,
                    ),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
