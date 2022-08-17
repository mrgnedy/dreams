import 'dart:developer';

import 'package:dreams/features/home/ro2ya/state/my_ro2yas_cubit.dart';
import 'package:dreams/features/home/ro2ya/ui/my_ro2yas.dart';
import 'package:dreams/features/notfications/data/notification_model.dart';
import 'package:dreams/features/notfications/state/notification_cubit.dart';
import 'package:dreams/helperWidgets/app_loader.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supercharged/supercharged.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';

class IndexModel {
  int index = 0;
  IndexModel(
    this.index,
  );
}

class NotificationScreen extends StatefulWidget {
  final NotificationCubit cubit;
  const NotificationScreen({Key? key, required this.cubit}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController position;
  IndexModel indexModel = IndexModel(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    position = AnimationController(vsync: this, duration: 200.ms);
    widget.cubit.getNotificion();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "الإشعارات",
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: BlocConsumer<NotificationCubit, NotificationModel>(
            bloc: widget.cubit,
            listener: (context, state) {
              if (state.state is SuccessResult) position.animateTo(0);
            },
            builder: (context, state) {
              if (state.state is LoadingResult && state.data.isEmpty) {
                return const AppLoader();
              }
              return Column(
                  children: state.data
                      .mapIndexedSC(
                        (e, index) => NotificationCard(
                          cubit: widget.cubit,
                          animation: position,
                          indexModel: indexModel,
                          currentIndex: index,
                        ),
                      )
                      .toList());
            },
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationCubit cubit;
  final AnimationController animation;
  final IndexModel indexModel;
  final int currentIndex;
  const NotificationCard(
      {Key? key,
      required this.animation,
      required this.cubit,
      required this.currentIndex,
      required this.indexModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final notificationData = cubit.state.data[currentIndex];
    return GestureDetector(
      onTap: () {
        log('notification: ${notificationData.data!.dream_id}');
        if (notificationData.data!.dream_id > 0) {
          final cubit = MyRo2yasCubit();
          BlocProvider.value(
            value: cubit,
            child: MyRo2yas(
              cubit: cubit,
              dreamId: notificationData.data!.dream_id,
            ),
          ).push(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 8.0.h),
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: animation.value,
                      duration: animation.duration!,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: cubit.state.state is LoadingResult
                              ? const AppLoader(
                                  isCentered: false,
                                )
                              : GestureDetector(
                                  onTap: () => cubit
                                      .deleteNotification(notificationData.id),
                                  child:
                                      Image.asset(R.ASSETS_IMAGES_DELETE_PNG)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragStart: (d) async {},
                    onHorizontalDragEnd: (d) async {
                      if (indexModel.index != currentIndex) {
                        await animation.reverse();
                      }
                      indexModel.index = currentIndex;
                      final isSliding =
                          d.velocity.pixelsPerSecond.dx.isNegative;
                      final isEn =
                          Directionality.of(context) == TextDirection.ltr;
                      if (isEn ? isSliding : !isSliding) {
                        animation.reverse();
                      } else {
                        animation.forward();
                      }
                    },
                    child: Transform.translate(
                      offset: currentIndex == indexModel.index
                          ? Offset(
                              (Directionality.of(context).index < 1 ? -1 : 1) *
                                  animation.value *
                                  0.4.sw,
                              0)
                          : Offset.zero,
                      child: child,
                    ),
                  ),
                ],
              );
            },
            child: Container(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Image.asset(
                              R.ASSETS_IMAGES_NOTIFICATION_BORDER_PNG)),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                          child: Column(
                            children: [
                              Text(
                                "${notificationData.data?.title}",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    end: 8.0.h, top: 8.h, bottom: 8.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(R.ASSETS_IMAGES_CLOCK_PNG),
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 8.0.w),
                                      child: Text(
                                        notificationData.created_at
                                            .split('T')
                                            .first,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${notificationData.data?.body}",
                                style: TextStyle(
                                    color: AppColors.blue, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
