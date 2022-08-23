import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/state/account.cubit.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/dialogs.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/const/resource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);
  final nameCtrler = TextEditingController();
  final emailCtrler = TextEditingController(text: di<AuthCubit>().state.email);
  final messageCtrler = TextEditingController();
  final cubit = AccountCubit();
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: LocaleKeys.contactUs.tr(),
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: BlocConsumer<AccountCubit, Result>(
          bloc: cubit,
          listener: (context, state) {
            if (state is DoneResult) {
              AppAlertDialog.show(
                  context, LocaleKeys.thanksForContactingUs.tr());
              context.pop();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: cubit.contactusState,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.r).copyWith(top: 40.h),
                      child: Image.asset(R.ASSETS_IMAGES_MESSAGE_PNG),
                    ),
                    Text(
                      LocaleKeys.weAreClose.tr(),
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0.h).copyWith(top: 8.h),
                      child: Text(
                        LocaleKeys.contactUsProblem.tr(),
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AppTextFormField(
                      hint: LocaleKeys.name.tr(),
                      validator: Validators.generalValidator,
                      leading: Image.asset(R.ASSETS_IMAGES_USER_PNG),
                      controller: nameCtrler,
                      onChanged: (s) {
                        nameCtrler.text = s;
                      },
                    ),
                    AppTextFormField(
                      hint: LocaleKeys.email.tr(),
                      validator: Validators.generalValidator,
                      leading: Image.asset(R.ASSETS_IMAGES_MAIL_PNG),
                      controller: emailCtrler,
                      onChanged: (s) {
                        emailCtrler.text = s;
                      },
                    ),
                    AppTextFormField(
                      leading: Image.asset(R.ASSETS_IMAGES_EDIT_PNG),
                      validator: Validators.generalValidator,
                      hint: LocaleKeys.msgBody.tr(),
                      controller: messageCtrler,
                      onChanged: (s) {
                        messageCtrler.text = s;
                      },
                      maxLines: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0.h),
                      child: GradientButton(
                        onTap: () {
                          cubit.contactUs(nameCtrler.text, emailCtrler.text,
                              messageCtrler.text);
                        },
                        title: LocaleKeys.sendMsg.tr(),
                        state: state,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
