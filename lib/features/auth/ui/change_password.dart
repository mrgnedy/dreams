import 'package:dreams/const/colors.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "كلمة المرور الجديدة",
      body: Center(
        child: SizedBox(
          width: 335.w,
          child: BlocConsumer<AuthCubit, AuthData>(
            bloc: di<AuthCubit>(),
            listener: (context, state) {
              if (state.state is SuccessResult) {
                const NavigationScreen().pushAndRemoveAll(context);
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
                        R.ASSETS_IMAGES_NEW_PASSWORD_PNG,
                        height: 170.h,
                        width: 170.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h, bottom: 20.w),
                        child: Text(
                          "كلمة المرور الجديدة",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 21.h),
                        child: Text(
                          'أدخل كلمة المرور الجديدة لحسابك',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: (15).sp, color: Colors.grey),
                        ),
                      ),
                      AppTextFormField(
                        hint: "كلمة المرور الجديدة",
                        onChanged: di<AuthCubit>().updatePassword,
                        leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                        textType: TextType.password,
                      ),
                      AppTextFormField(
                        hint: "أدخل كلمة المرور الجديدة",
                        onChanged: di<AuthCubit>().updateConfirmPassword,
                        leading: Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG),
                        textType: TextType.password,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: GradientButton(
                            state: state.state,
                            onTap: di<AuthCubit>().resetPassword,
                            title: 'حفظ'),
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
