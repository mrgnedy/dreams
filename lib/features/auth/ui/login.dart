// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/auth/ui/validate_code.dart';
import 'package:dreams/helperWidgets/app_checkbox.dart';
import 'package:dreams/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/register.dart';
import 'package:dreams/features/auth/ui/forgot_password.dart';
import 'package:dreams/features/home/ui/navigation_screen.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/dialogs.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final authCubit = di<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(context.locale);
    return MainScaffold(
      title: LocaleKeys.login.tr(),
      body: Center(
        child: SizedBox(
          width: 335.w,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: BlocConsumer<AuthCubit, AuthData>(
                bloc: authCubit,
                listener: (context, state) {
                  if (state.state is SuccessResult &&
                      ModalRoute.of(context)!.isCurrent) {
                    if (state.state.getSuccessData())
                      const NavigationScreen().pushAndRemoveAll(context);
                    else
                      const ValidateCodeScreen().push(context);
                    authCubit.updateState(
                        state.copyWith(state: const Result.init()));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: authCubit.loginFormState,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          R.ASSETS_IMAGES_LOGIN_PNG,
                          height: 170.h,
                          width: 170.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, bottom: 12.w),
                          child: Text(
                            LocaleKeys.login.tr(),
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 21.h),
                          child: Text(
                            LocaleKeys.loginWithYourAccount.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.5,
                                fontSize: (15).sp,
                                color: Colors.grey),
                          ),
                        ),
                        AppTextFormField(
                          validator: Validators.email,
                          onChanged: authCubit.updateMail,
                          hint: LocaleKeys.email.tr(),
                          leading: Image.asset(R.ASSETS_IMAGES_MAIL_PNG),
                        ),
                        AppTextFormField(
                          validator: Validators.passowrd,
                          hint: LocaleKeys.password.tr(),
                          onChanged: authCubit.updatePassword,
                          textType: TextType.password,
                          leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                          trailing: Image.asset(R.ASSETS_IMAGES_OBSECURE_PNG),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const RememberAndForget(),
                        ),
                        GradientButton(
                          state: state.state,
                          onTap: authCubit.login,
                          title: LocaleKeys.login.tr(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: GestureDetector(
                              child: Text(LocaleKeys.dontHaveAccount.tr())),
                        ),
                        SimpleButton(
                            onTap: () =>
                                const RegisterScreen().pushReplace(context),
                            title: LocaleKeys.createAccount.tr()),
                        GestureDetector(
                          onTap: () => const NavigationScreen().push(context),
                          child: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: Text(
                              LocaleKeys.skip.tr(),
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RememberAndForget extends StatelessWidget {
  const RememberAndForget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<AuthCubit, AuthData>(
          bloc: di<AuthCubit>(),
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                di<AuthCubit>().updateRemember(!state.isRemember);
              },
              child: AppCheckBox(
                text: LocaleKeys.rememberMe.tr(),
                isChecked: state.isRemember,
              ),
            );
          },
        ),
        InkWell(
          onTap: () {
            const ForgotPasswordScreen().push(context);
          },
          child: Text(
            LocaleKeys.forgotPassword.tr(),
          ),
        )
      ],
    );
  }
}
