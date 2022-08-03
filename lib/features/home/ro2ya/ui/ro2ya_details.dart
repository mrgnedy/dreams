// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ro2ya/state/my_ro2yas.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supercharged/supercharged.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/data/models/dreams_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:dreams/features/home/ro2ya/ui/commonWidgets/moaber_sepcs.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';

class RoyaDetailsScreen extends StatelessWidget {
  final DreamData dreamData;
  const RoyaDetailsScreen({
    Key? key,
    required this.dreamData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: dreamData.title.characters.take(15).toList().join(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequestInfo(dreamData: dreamData),
              UserDetails(),
              if (dreamData.interpreter_answer.isNotEmpty)
                Moaber(data: dreamData.interpreter),
              RoyaDetails(dream: dreamData.title),
              if (dreamData.interpreter_answer.isNotEmpty)
                Column(
                  children: [
                    Tafseer(
                      dreamData: dreamData,
                    ),
                    Estedlal(
                      dreamData: dreamData,
                    )
                  ],
                ),
              if (isProvider() && dreamData.status != 'answered')
                BlocConsumer<MyRo2yasCubit, DreamsModel>(
                  listener: (context, state) async {
                    // TODO: implement listener
                    Fluttertoast.showToast(msg: 'تم ارسال ردك بنجاح');
                    await BlocProvider.of<MyRo2yasCubit>(context).getMyDreams();
                    context.pop();
                  },
                  builder: (context, state) {
                    return GradientButton(
                        state: state.state,
                        onTap: () {
                          BlocProvider.of<MyRo2yasCubit>(context)
                              .submitAnswer(dreamData.id);
                        },
                        title: 'إرسال الرد');
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commonStyle = TextStyle(fontSize: 15.sp, color: AppColors.blue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h),
          child: const _SubTitle("طالب التفسير"),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.blue.withOpacity(0.06),
          ),
          child: Row(

            children: [
              Expanded(
                  child: Image.asset(R.ASSETS_IMAGES_TEST_PROFILE_AT_2X_PNG)),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'test',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          R.ASSETS_IMAGES_BRONZE_PKG_PNG)),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        'data',
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          R.ASSETS_IMAGES_FLASH_PNG)),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        'data',
                                        style: commonStyle,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          R.ASSETS_IMAGES_FLASH_PNG)),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        'data',
                                        style: commonStyle,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          R.ASSETS_IMAGES_FLASH_PNG)),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        'data',
                                        style: commonStyle,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          R.ASSETS_IMAGES_FLASH_PNG)),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        'data',
                                        style: commonStyle,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Estedlal extends StatelessWidget {
  final DreamData dreamData;
  const Estedlal({
    Key? key,
    required this.dreamData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TextWithTitle('وجه الإستدلال', dreamData.interpreter_answer2,
        isTextField: dreamData.interpreter_id == di<AuthCubit>().state.id,
        onChanged: BlocProvider.of<MyRo2yasCubit>(context).updateEstedlal);
  }
}

class Tafseer extends StatelessWidget {
  final DreamData dreamData;
  const Tafseer({
    Key? key,
    required this.dreamData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TextWithTitle(
      'التعبير / التفسير',
      dreamData.interpreter_answer,
      isTextField: dreamData.interpreter_id == di<AuthCubit>().state.id,
      onChanged: BlocProvider.of<MyRo2yasCubit>(context).updateTafser,
    );
  }
}

class RoyaDetails extends StatelessWidget {
  final String dream;
  const RoyaDetails({
    Key? key,
    required this.dream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TextWithTitle('تفاصيل الرؤيا', dream);
  }
}

class _TextWithTitle extends StatelessWidget {
  final String title;
  final String txt;
  final bool isTextField;
  final Function(String)? onChanged;
  const _TextWithTitle(
    this.title,
    this.txt, {
    this.isTextField = false,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: _SubTitle(title),
        ),
        if (isTextField)
          AppTextFormField(
            hint: 'sa',
            maxLines: 4,
            onChanged: onChanged,
          )
        else
          Text(
            txt,
            style: TextStyle(fontSize: 15.sp),
          ),
        Padding(
          padding: EdgeInsets.only(top: 36.h),
          child: const Divider(),
        ),
      ],
    );
  }
}

class Moaber extends StatelessWidget {
  final MoaberData data;
  const Moaber({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h),
          child: const _SubTitle("معلومات الطلب"),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(child: Image.asset(R.ASSETS_IMAGES_TEST_PROFILE_PNG)),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معمر المطيري',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    // const MoaberSpecs()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String txt;
  const _SubTitle(
    this.txt, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RequestInfo extends StatelessWidget {
  final DreamData dreamData;
  const RequestInfo({
    Key? key,
    required this.dreamData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h),
          child: const _SubTitle("معلومات الطلب"),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(R.ASSETS_IMAGES_TIME_BLUE_PNG),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 8.0.w),
                          child: Text(
                            'وقت الطلب',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      dreamData.createdAt.split("T").first,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(R.ASSETS_IMAGES_WAITING_PNG),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 8.0.w),
                          child: Text(
                            'حالة الطلب',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      dreamData.interpreter_answer.isNotEmpty
                          ? 'تم رد المعبر'
                          : "فى انتظار رد المعبر",
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
