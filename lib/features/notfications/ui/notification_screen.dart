import 'dart:developer';

import 'package:flutter/material.dart';
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
  const NotificationScreen({Key? key}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "الإشعارات",
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
              children: 1
                  .rangeTo(10)
                  .map(
                    (e) => NotificationCard(
                      animation: position,
                      indexModel: indexModel,
                      currentIndex: e,
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final AnimationController animation;
  final IndexModel indexModel;
  final int currentIndex;
  const NotificationCard(
      {Key? key,
      required this.animation,
      required this.currentIndex,
      required this.indexModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        child: Image.asset(R.ASSETS_IMAGES_DELETE_PNG),
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
                    final isSliding = d.velocity.pixelsPerSecond.dx.isNegative;
                    final isEn =
                        Directionality.of(context) == TextDirection.ltr;
                    if (isEn ? isSliding : !isSliding)
                      animation.reverse();
                    else
                      animation.forward();
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
                              'المعبر معمر المطيري متاح حاليا لتفسير الرؤى',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(R.ASSETS_IMAGES_CLOCK_PNG),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 8.0.w),
                                    child: Text(
                                      "الأربعاء , 5 يوليو 2022",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "مستعد ذهنيا لتفسير منامكم خلال الساعة",
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
    );
  }
}
