// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dreams/helperWidgets/app_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:dreams/features/home/ro2ya/ui/mo3aberen_list.dart';
import 'package:dreams/helperWidgets/app_checkbox.dart';
import 'package:dreams/helperWidgets/app_radio_group.dart';
import 'package:dreams/helperWidgets/app_tab_bar.dart';
import 'package:dreams/helperWidgets/app_text_field.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/base_state.dart';

import '../state/roya_request_state.dart';

class TaabeerRequest extends StatelessWidget {
  final MoaberData moaberData;
  const TaabeerRequest({
    Key? key,
    required this.moaberData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      // title: "طلب تعبير رؤيا",
      isAppBarFixed: true,
      gradientAreaHeight: 190,
      body: Padding(
        padding: EdgeInsets.only(top: 48.0.h),
        child: Builder(builder: (context) {
          return BlocBuilder<RoyaRequestCubit, QuestionsModel>(
            builder: (context, state) {
              final cubit = BlocProvider.of<RoyaRequestCubit>(context);
              if (state.state is LoadingResult) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.state is ErrorResult) {
                return AppErrorWidget(
                  error: state.state.getErrorMessage(),
                  onError: cubit.getQuestions,
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: AppBackButton(isAppBarFixed: false)),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "طلب تعبير رؤيا",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0.w).copyWith(top: 26.h),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.blueGrey,
                          borderRadius: BorderRadius.circular(16)),
                      child: MoaberDetailsCard(
                        moaberData: moaberData,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: 0.9.sw,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50.h,
                                child: const AppTabBar(
                                  tabs: [
                                    Text('محتوى الرؤية'),
                                    Text('تسجيل صوتي'),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0.h),
                                child: AppTextFormField(
                                  hint: " ... موضوع الرؤيا",
                                  onChanged:
                                      BlocProvider.of<RoyaRequestCubit>(context)
                                          .updateTitle,
                                ),
                              ),

                              ...List.generate(
                                state.data!.length,
                                (index) {
                                  final question = state.data![index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0.h),
                                    child: question.selects is List &&
                                            question.selects.isNotEmpty
                                        ? AppRadioGroupWithTitle(
                                            items: (question.selects
                                                    as List<Select>)
                                                .map((e) => e.answer)
                                                .toList(),
                                            onSelected: (s) => BlocProvider.of<
                                                    RoyaRequestCubit>(context)
                                                .updateAnswer(
                                                    question.id,
                                                    (question.selects[s]
                                                            as Select)
                                                        .answer),
                                            title: question.question,
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0.h),
                                                child: Text(
                                                  question.question,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 15.sp),
                                                ),
                                              ),
                                              AppTextFormField(
                                                hint: question.placeHolder!,
                                                onChanged: (s) => BlocProvider
                                                        .of<RoyaRequestCubit>(
                                                            context)
                                                    .updateAnswer(
                                                        question.id, s),
                                                maxLines:
                                                    question.type == 'textarea'
                                                        ? 3
                                                        : 1,
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),

                              // const AppRadioGroupWithTitle(
                              //   items: ["لنفسي", "لغيرى"],
                              //   title: " هل شاهدت الرؤيا بنفسك أم تسأل لغيرك ؟",
                              // ),
                              // const AppRadioGroupWithTitle(
                              //   items: ["متزوج", "أعزب", "منفصل"],
                              //   title: "الحالة الإجتماعية",
                              // ),
                              // const AppRadioGroupWithTitle(
                              //   items: ["نعم", "لا"],
                              //   title: "هل يعاني الرائي من مرض بدني أو روحي ؟",
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 16.0.h),
                              //   child: Text(
                              //     "ما يشغل الرائي قبل الرؤيا ؟",
                              //     style: TextStyle(fontSize: 15.sp),
                              //   ),
                              // ),
                              // AppTextFormField(
                              //   hint: ' ... أكتب تفاصيل',
                              //   onChanged: (s) {},
                              //   maxLines: 3,
                              // ),
                              // AppTextFormField(
                              //   hint: "تاريخ الرؤيا",
                              //   textType: TextType.date,
                              //   onChanged: (s) {},
                              // ),
                              // AppTextFormField(
                              //   hint: "الوظيفة / طبيعة العمل",
                              //   onChanged: (s) {},
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 12.0.h),
                              //   child: Text(
                              //     "معلومات إضافية عن حالة الرائي",
                              //     style: TextStyle(fontSize: 15.sp),
                              //   ),
                              // ),
                              // AppTextFormField(
                              //   hint: ' ... أكتب تفاصيل',
                              //   onChanged: (s) {},
                              //   maxLines: 3,
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              //   child: const AppRadioGroupWithTitle(
                              //     items: ['نعم', "لا"],
                              //     title:
                              //         "هل الرؤية بعد إستخارة أو حدث مؤثر معين ؟",
                              //   ),
                              // ),
                              // Text(
                              //   "تفاصيل الرؤيا",
                              //   style: TextStyle(fontSize: 15.sp),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 16.0.h),
                              //   child: AppTextFormField(
                              //     hint: ' ... أكتب تفاصيل',
                              //     onChanged: (s) {},
                              //     maxLines: 3,
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0.h),
                                child: const AppCheckBox(
                                    text: 'أريد إظهار الرؤيا للمستخدمين',
                                    isChecked: true),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: GradientButton(
                                  onTap:
                                      BlocProvider.of<RoyaRequestCubit>(context)
                                          .submitAnswer,
                                  title: 'إرسال الطلب',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
