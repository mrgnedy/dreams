import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/register.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/app_checkbox.dart';
import 'package:dreams/helperWidgets/app_drop_down.dart';
import 'package:dreams/helperWidgets/app_radio_group.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            icon: R.ASSETS_IMAGES_PHONE_PNG,
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
            type: DropdownButton,
            icon: R.ASSETS_IMAGES_NATIONALITY_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.city:
        return CardItem(
            name: LocaleKeys.city.tr(),
            subTitle: '',
            type: DropdownButton,
            icon: R.ASSETS_IMAGES_LOCATION_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.birthdate:
        return CardItem(
            name: LocaleKeys.birthdate.tr(),
            subTitle: '',
            type: TextType.date,
            icon: R.ASSETS_IMAGES_CALENDAR_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.job:
        return CardItem(
            name: LocaleKeys.yourJob.tr(),
            subTitle: '',
            icon: R.ASSETS_IMAGES_JOB_PNG,
            onPressed: (s) => log('$s'));

      case ProfileFieldSelector.gender:
        return CardItem(
            name: LocaleKeys.gender.tr(),
            subTitle: '',
            type: Checkbox,
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
    final authCubit = AuthCubit()
      ..getCountries()
      ..updateGender(userData.gender!);

    log("birth:${userData.birthDate}");
    return MainScaffold(
      title: "تعديل المعلومات الشخصية",
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
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
              AppTextFormField(
                hint: "إسم المستخدم",
                initValue: userData.name!,
                validator: Validators.name,
                onChanged: authCubit.updateName,
                leading: Image.asset(R.ASSETS_IMAGES_USER_PNG),
              ),
              AppTextFormField(
                hint: "البريد الالكتروني",
                initValue: userData.email!,
                validator: Validators.email,
                onChanged: authCubit.updateMail,
                leading: Image.asset(R.ASSETS_IMAGES_MAIL_PNG),
              ),
              AppTextFormField(
                hint: "رقم الجوال",
                initValue: userData.mobile!,
                validator: Validators.phone,
                onChanged: authCubit.updateMobile,
                leading: Image.asset(R.ASSETS_IMAGES_PHONE_PNG),
              ),
              BlocConsumer<AuthCubit, AuthData>(
                bloc: authCubit,
                listener: (context, state) {
                  if (state.country?.id == null) {
                    final country = state.countries?.firstWhere(
                      (element) => element?.id == userData.country?.id,
                    );
                    if (country?.id != null) {
                      authCubit.updateCountry(country);
                      authCubit.updateCity(userData.city);
                    }
                  }
                },
                builder: (context, state) {
                  return (state.state is LoadingResult)
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            AppDropdownButton<CountryData>(
                              items: state.countries,
                              validator: (_) => Validators.country<CountryData>(
                                  state.country),
                              icon: R.ASSETS_IMAGES_NATIONALITY_PNG,
                              value: state.country,
                              hint: LocaleKeys.country.tr(),
                              onChanged: authCubit.updateCountry,
                            ),
                            AppDropdownButton<CountryData>(
                              items: state.cities,
                              icon: R.ASSETS_IMAGES_LOCATION_PNG,
                              validator: (_) => Validators.city(state.country),
                              value: state.city,
                              hint: LocaleKeys.city.tr(),
                              onChanged: authCubit.updateCity,
                            ),
                          ],
                        );
                },
              ),
              AppTextFormField(
                hint: "تاريخ الميلاد",
                initValue: userData.birthDate!,
                onChanged: authCubit.updateBirthdate,
                validator: Validators.birthdate,
                textType: TextType.date,
                leading: Image.asset(R.ASSETS_IMAGES_CALENDAR_PNG),
              ),
              AppTextFormField(
                hint: "أكتب وظيفتك",
                initValue: userData.job!,
                validator: Validators.job,
                onChanged: authCubit.updateJob,
                leading: Image.asset(R.ASSETS_IMAGES_JOB_PNG),
              ),
              //
              GenderSelect(
                authCubit: authCubit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
