// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/helperWidgets/app_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/data/models/dreams_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:dreams/features/home/ro2ya/state/my_ro2yas_cubit.dart';
import 'package:dreams/features/home/ro2ya/state/roya_request_cubit.dart';
import 'package:dreams/features/home/ro2ya/ui/ro2ya_details.dart';
import 'package:dreams/helperWidgets/app_error_widget.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';

class MyRo2yas extends StatefulWidget {
  // final MyRo2yasCubit cubit;
  final int dreamId;
  const MyRo2yas({
    Key? key,
    // required this.cubit,
    this.dreamId = 0,
  }) : super(key: key);

  @override
  State<MyRo2yas> createState() => _MyRo2yasState();
}

class _MyRo2yasState extends State<MyRo2yas> {
  final scrollCtrler = ScrollController();

  late MyRo2yasCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      cubit = BlocProvider.of<MyRo2yasCubit>(context);
    } catch (e) {
      cubit = MyRo2yasCubit();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await cubit.getMyDreams();
      Future.delayed(0.s, () {
        if (widget.dreamId > 0) {
          BlocProvider.value(
            value: cubit,
            child: RoyaDetailsScreen(
              cubit: cubit,
              dreamData: cubit.state.data.firstWhere(
                (element) => element.id == widget.dreamId,
              ),
            ),
          ).push(context);
        }
      });
      scrollCtrler.addListener(() {
        if (scrollCtrler.position.maxScrollExtent + 100 < scrollCtrler.offset) {
          cubit.getMyDreams(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title:
          (isProvider() ? LocaleKeys.dreamRequests : LocaleKeys.myDreams).tr(),
      body: BlocBuilder<MyRo2yasCubit, DreamsModel>(
        bloc: cubit,
        builder: (context, state) {
          if (state.state is LoadingResult && state.data.isEmpty) {
            return const AppLoader();
          }
          if (state.state is ErrorResult) {
            return AppErrorWidget(
              error: state.state.getErrorMessage(),
              onError: cubit.getMyDreams,
            );
          }
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: scrollCtrler,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final dreamData = state.data[index];
                    return GestureDetector(
                      onTap: () => BlocProvider.value(
                        value: cubit,
                        child: RoyaDetailsScreen(
                          cubit: cubit,
                          dreamData: dreamData,
                        ),
                      ).push(context),
                      child: Ro2yaCard(
                        dreamData: dreamData,
                      ),
                    );
                  },
                ),
              ),
              if (state.state is LoadingResult)
                const Expanded(child: AppLoader())
            ],
          );
        },
      ),
    );
  }
}

class Ro2yaCard extends StatelessWidget {
  final DreamData dreamData;
  const Ro2yaCard({
    Key? key,
    required this.dreamData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dreamData.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Image.asset(R.ASSETS_IMAGES_CLOCK_PNG),
                      Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          dreamData.createdAt.split('T').first,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.all(16.w),
                        child: Image.asset(R.ASSETS_IMAGES_WAITING_PNG),
                      ),
                      Text(
                        DreamStatus.status(dreamData.status),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // if (dreamData.interpreter_answer.isNotEmpty)
              Column(
                children: [
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 5.0.w),
                          child: CircleAvatar(
                            radius: 40.h,
                            
                            backgroundImage: NetworkImage(
                              dreamData.interpreter.image,
                            ),
                            // clipper: CustomClipper<Rect>(),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(100)),
                            // child: Container(
                            //   color: AppColors.blue.withOpacity(0.2),
                            //   child: Image.network(
                            //     dreamData.interpreter.image,
                            //     height: 80.r,
                            //     width: 80.r,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          dreamData.interpreter.name,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
