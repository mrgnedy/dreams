import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/reset_password.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/features/auth/ui/validate_code.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: LocaleKeys.resetPassowrd.tr(),
      body: Center(
        child: SizedBox(
          width: 335.w,
          child: BlocConsumer<AuthCubit, AuthData>(
            bloc: di<AuthCubit>(),
            listener: (context, state) {
              if (state.state is SuccessResult) {
                const ValidateCodeScreen(isForget: true,).pushReplace(context);
                di<AuthCubit>().updateState(state.copyWith(state: Result.init()));
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
                        R.ASSETS_IMAGES_RESET_PASS_PNG,
                        height: 170.h,
                        width: 170.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h, bottom: 20.w),
                        child: Text(
                          LocaleKeys.resetPassowrd.tr(),
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 21.h),
                        child: Text(
                          LocaleKeys.enterMailToReset.tr(),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: (15).sp, color: Colors.grey),
                        ),
                      ),
                      Form(
                        key: di<AuthCubit>().sendCodeFormState,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: AppTextFormField(
                          hint: LocaleKeys.email.tr(),
                          onChanged: di<AuthCubit>().updateMail,
                          validator: Validators.email,
                          leading: Image.asset(R.ASSETS_IMAGES_MAIL_PNG),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: GradientButton(
                            state: state.state,
                            onTap: di<AuthCubit>().forgetPassword,
                            title: LocaleKeys.send.tr()),
                      ),
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
