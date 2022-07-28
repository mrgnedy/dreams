import 'dart:developer';

import 'package:dreams/features/auth/ui/reset_password.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/change_password.dart';
import 'package:dreams/features/home/ui/navigation_screen.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';

class ValidateCodeScreen extends StatelessWidget {
  final bool isForget;
  const ValidateCodeScreen({
    Key? key,
    this.isForget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "إسترجاع كلمة المرور",
      body: Center(
        child: SizedBox(
          width: 335.w,
          child: BlocConsumer<AuthCubit, AuthData>(
            bloc: di<AuthCubit>(),
            listener: (context, state) {
              if (state.state is SuccessResult &&
                  ModalRoute.of(context)!.isActive) {
                if (isForget) {
                  const ResetPasswordScreen().pushReplace(context);
                } else {
                  const NavigationScreen().pushAndRemoveAll(context);
                }
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        R.ASSETS_IMAGES_SEND_CODE_PNG,
                        height: 170.h,
                        width: 170.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h, bottom: 20.w),
                        child: Text(
                          "إسترجاع كلمة المرور",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 21.h),
                        child: Text.rich(
                          TextSpan(
                            text: LocaleKeys.enterSentCode.tr(),
                            children: const [
                              TextSpan(
                                  text: "\ninfo@gmail.com",
                                  style: TextStyle(color: AppColors.blue)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: (15).sp, color: Colors.grey),
                        ),
                      ),
                      AppTextFormField(
                        hint: LocaleKeys.enterCode.tr(),
                        onChanged: di<AuthCubit>().updateCode,
                        leading: Image.asset(R.ASSETS_IMAGES_ENTER_CODE_PNG),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: GradientButton(
                          state: state.state,
                            onTap: di<AuthCubit>().validateCode,
                            title: 'إرسال'),
                      ),
                      // const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: Text.rich(
                          TextSpan(
                            text: LocaleKeys.codeNotReceived.tr(),
                            children: [
                              TextSpan(
                                  text: LocaleKeys.resend.tr(),
                                  style:
                                      const TextStyle(color: AppColors.green)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: (15).sp, color: Colors.black),
                        ),
                      )
                    ],
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

class RememberAndForget extends StatelessWidget {
  const RememberAndForget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24.r,
              width: 24.r,
              child: Image.asset(R.ASSETS_IMAGES_CHECK_PNG),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0.h),
              child: const Text('تذكرني'),
            )
          ],
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            "نسيت كلمد المرور؟",
          ),
        )
      ],
    );
  }
}
