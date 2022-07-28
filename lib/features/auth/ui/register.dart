import 'dart:developer';
import 'dart:ui';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/features/auth/data/models/country_model.dart';
import 'package:dreams/features/auth/ui/validate_code.dart';
import 'package:dreams/features/home/ui/navigation_screen.dart';
import 'package:dreams/helperWidgets/app_drop_down.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/login.dart';
import 'package:dreams/features/auth/ui/reset_password.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/dialogs.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authCubit = di<AuthCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authCubit.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "إنشاء حساب جديد",
      body: Center(
        child: SizedBox(
          width: 335.w,
          child: BlocConsumer<AuthCubit, AuthData>(
            bloc: authCubit,
            listener: (context, state) {
              if (state.state is SuccessResult &&
                  state.state.getSuccessData() == true &&
                  ModalRoute.of(context)!.isActive)
                const ValidateCodeScreen().pushReplace(context);
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Form(
                    key: authCubit.registerFormState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          R.ASSETS_IMAGES_ADD_USER_PNG,
                          height: 170.h,
                          width: 170.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, bottom: 20.w),
                          child: Text(
                            "إنشاء حساب جديد",
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 21.h),
                          child: Text(
                            'سجل دخول لحسابك على أذكاري ورؤياي',
                            style: TextStyle(
                                fontSize: (15).sp, color: Colors.grey),
                          ),
                        ),
                        AppTextFormField(
                          hint: "إسم المستخدم",
                          validator: Validators.name,
                          onChanged: authCubit.updateName,
                          leading: Image.asset(R.ASSETS_IMAGES_USER_PNG),
                        ),
                        AppTextFormField(
                          hint: "البريد الالكتروني",
                          validator: Validators.email,
                          onChanged: authCubit.updateMail,
                          leading: Image.asset(R.ASSETS_IMAGES_MAIL_PNG),
                        ),
                        AppTextFormField(
                          hint: "رقم الجوال",
                          validator: Validators.phone,
                          onChanged: authCubit.updateMobile,
                          leading: Image.asset(R.ASSETS_IMAGES_PHONE_PNG),
                        ),
                        BlocBuilder<AuthCubit, AuthData>(
                          bloc: authCubit,
                          // buildWhen: (previous, current) => true,
                          //     previous.countries == null && current.countries != null,
                          builder: (context, state) {
                            return (state.state is LoadingResult &&
                                    state.countries == null)
                                ? const CircularProgressIndicator()
                                : Column(
                                    children: [
                                      AppDropdownButton<CountryData>(
                                        items: state.countries,
                                        validator: (_) =>
                                            Validators.country<CountryData>(
                                                state.country),
                                        icon: R.ASSETS_IMAGES_NATIONALITY_PNG,
                                        value: state.country,
                                        hint: LocaleKeys.country.tr(),
                                        onChanged: (e) {
                                          authCubit.updateCountry(e);
                                        },
                                      ),
                                      AppDropdownButton<CountryData>(
                                        items: state.cities,
                                        icon: R.ASSETS_IMAGES_LOCATION_PNG,
                                        validator: (_) =>
                                            Validators.city(state.country),
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
                          onChanged: authCubit.updateBirthdate,
                          validator: Validators.birthdate,
                          textType: TextType.date,
                          leading: Image.asset(R.ASSETS_IMAGES_CALENDAR_PNG),
                        ),
                        AppTextFormField(
                          hint: "أكتب وظيفتك",
                          validator: Validators.job,
                          onChanged: authCubit.updateJob,
                          leading: Image.asset(R.ASSETS_IMAGES_JOB_PNG),
                        ),
                        //
                        GenderSelect(
                          authCubit: authCubit,
                        ),
                        AppTextFormField(
                          hint: "كلمة المرور",
                          validator: Validators.passowrd,
                          textType: TextType.password,
                          onChanged: authCubit.updatePassword,
                          leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                          trailing: Image.asset(R.ASSETS_IMAGES_OBSECURE_PNG),
                        ),
                        AppTextFormField(
                          hint: "تأكيد كلمة المرور",
                          validator: Validators.passConfirmowrd,
                          textType: TextType.password,
                          onChanged: authCubit.updateConfirmPassword,
                          leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                          trailing: Image.asset(R.ASSETS_IMAGES_OBSECURE_PNG),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: GradientButton(
                              state: state.state,
                              onTap:  authCubit.register ,
                              title: LocaleKeys.createAccount.tr()),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: GestureDetector(
                              child: const Text('لديك حساب بالفعل ؟')),
                        ),
                        SimpleButton(
                            onTap: () => LoginScreen().pushReplace(context),
                            title: "تسجيل دخول"),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GenderSelect extends StatelessWidget {
  final AuthCubit authCubit;
  const GenderSelect({Key? key, required this.authCubit}) : super(key: key);
  int get groupValue => authCubit.state.gender ?? 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("الجنس"),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [buildRadio(1), const Text('ذكر')],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [buildRadio(0), const Text('أنثى')],
            ),
          ],
          // children[]
        )
      ],
    );
  }

  Widget buildRadio(int value) {
    // print(window.devicePixelRatio);
    return BlocBuilder<AuthCubit, AuthData>(
      bloc: authCubit,
      // buildWhen: (previous, current) => previous.gender != current.gender,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 10.w, right: 15.w),
          child: GestureDetector(
            onTap: () {
              print('$value');
              authCubit.updateGender(value);
            },
            child: value == groupValue
                ? const Image(
                    image: AssetImage(R.ASSETS_IMAGES_CHECK_BLUE_PNG)) //1479
                : Container(
                    height: 24.h,
                    width: 24.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.blue),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
