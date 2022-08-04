// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/data/models/dreams_model.dart';
import 'package:dreams/features/home/ro2ya/data/models/questions_model.dart';
import 'package:dreams/features/home/ro2ya/state/my_ro2yas.dart';
import 'package:dreams/features/home/ro2ya/state/roya_request_state.dart';
import 'package:dreams/features/home/ro2ya/ui/ro2ya_details.dart';
import 'package:dreams/helperWidgets/app_error_widget.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';

class MyRo2yas extends StatefulWidget {
  final MyRo2yasCubit cubit;
  MyRo2yas({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  State<MyRo2yas> createState() => _MyRo2yasState();
}

class _MyRo2yasState extends State<MyRo2yas> {
  final scrollCtrler = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      scrollCtrler.addListener(() {
        if (scrollCtrler.position.maxScrollExtent + 100 < scrollCtrler.offset) {
          widget.cubit.getMyDreams(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'سجل الرؤى',
      body: BlocBuilder<MyRo2yasCubit, DreamsModel>(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state.state is LoadingResult && state.data.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.state is ErrorResult) {
            return AppErrorWidget(
              error: state.state.getErrorMessage(),
              onError: widget.cubit.getMyDreams,
            );
          }
          return Column(
            children: [
              Expanded(flex: 2,
                child: ListView.builder(
                  controller: scrollCtrler,
                  itemCount: state.data.length ,
                  itemBuilder: (context, index) {
                    final dreamData = state.data[index];
                    return GestureDetector(
                      onTap: () => BlocProvider.value(
                        value: widget.cubit,
                        child: RoyaDetailsScreen(
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
               const Expanded(child:   Center(child: CircularProgressIndicator()))
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
                        dreamData.status,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (dreamData.interpreter_answer.isNotEmpty)
                Column(
                  children: [
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Image.network(dreamData.interpreter.image)),
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
