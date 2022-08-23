import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ui/navigation_screen.dart';
import 'package:dreams/helperWidgets/dialogs.dart';
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

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = di<AuthCubit>();
    return MainScaffold(
      title: LocaleKeys.changePassword.tr(),
      body: Center(
        child: SizedBox(
          width: 335.w,
          child: BlocConsumer<AuthCubit, AuthData>(
            bloc: authCubit,
            listener: (context, state) async {
              if (state.state is SuccessResult) {
                await AppAlertDialog.show(
                    context, LocaleKeys.passwordChangedSuccessfully.tr());
                context.pop();
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Image.asset(
                        R.ASSETS_IMAGES_NEW_PASSWORD_PNG,
                        height: 170.h,
                        width: 170.w,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 30.h, bottom: 20.w),
                    //   child: Text(
                    //     "كلمة المرور الجديدة",
                    //     style: TextStyle(
                    //       fontSize: 25.sp,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(bottom: 21.h),
                    //   child: Text(
                    //     'أدخل كلمة المرور الجديدة لحسابك',
                    //     textAlign: TextAlign.center,
                    //     style:
                    //         TextStyle(fontSize: (15).sp, color: Colors.grey),
                    //   ),
                    // ),
                    AppTextFormField(
                      hint: LocaleKeys.oldPassword.tr(),
                      onChanged: authCubit.updateOldPassword,
                      validator: Validators.passowrd,
                      leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                      textType: TextType.password,
                    ),
                    AppTextFormField(
                      hint: LocaleKeys.newPassword.tr(),
                      onChanged: authCubit.updatePassword,
                      leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                      validator: Validators.passowrd,
                      textType: TextType.password,
                    ),
                    AppTextFormField(
                      hint:
                          "${LocaleKeys.confirm.tr()} ${LocaleKeys.newPassword.tr()}",
                      onChanged: authCubit.updateConfirmPassword,
                      validator: (s) => Validators.passConfirmowrd(
                          s, authCubit.state.password),
                      leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                      textType: TextType.password,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: GradientButton(
                        state: state.state,
                        onTap: authCubit.changePassword,
                        title: LocaleKeys.save.tr(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
