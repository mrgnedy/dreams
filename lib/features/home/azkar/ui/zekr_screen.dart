import 'dart:math';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/app_tab_bar.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';

import 'package:dreams/features/home/azkar/ui/azkar_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZekrScreen extends StatefulWidget {
  final List<ZekrData> zekrData;
  final String zekrCategory;
  ZekrScreen({
    Key? key,
    required this.zekrData,
    required this.zekrCategory,
  }) : super(key: key);

  @override
  State<ZekrScreen> createState() => _ZekrScreenState();
}

class _ZekrScreenState extends State<ZekrScreen> {
  int currentZekr = 0;

  // int repeats = 0;

  @override
  Widget build(BuildContext context) {
    // ZekrData zekr = widget.zekrData[currentZekr];
    return MainScaffold(
      title: widget.zekrCategory,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                widget.zekrCategory,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
            const ZekrTabs(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.blue),
                  ),
                  child: Column(
                    children: [
                      ZekrTabView(widget: widget, currentZekr: currentZekr),
                      ReadCounter(
                        widget: widget,
                        currentZekr: currentZekr,
                        resetCallback: resetCounter,
                        readCallback: readZekr,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ZekrController(
              currentZekr: currentZekr,
              widget: widget,
              previousCallback: previousZekr,
              nextCallback: nextZekr,
            ),
          ],
        ),
      ),
    );
  }

  void readZekr() {
    setState(() {
      widget.zekrData[currentZekr] = widget.zekrData[currentZekr].copyWith(
          done: (widget.zekrData[currentZekr].done + 1)
              .clamp(0, widget.zekrData[currentZekr].count));
    });
    if (widget.zekrData[currentZekr].done ==
        widget.zekrData[currentZekr].count) {
      Future.delayed(200.ms, () {
        setState(() {
          currentZekr = (currentZekr + 1).clamp(0, widget.zekrData.length - 1);
        });
      });
    }
  }

  void resetCounter() {
    setState(() {
      widget.zekrData[currentZekr] =
          widget.zekrData[currentZekr].copyWith(done: 0);
    });
  }

  void previousZekr() {
    setState(() {
      currentZekr = (currentZekr - 1).clamp(0, widget.zekrData.length - 1);
    });
  }

  void nextZekr() {
    setState(() {
      currentZekr = (currentZekr + 1).clamp(0, widget.zekrData.length - 1);
    });
  }
}

class ZekrController extends StatelessWidget {
  const ZekrController({
    Key? key,
    required this.currentZekr,
    required this.previousCallback,
    required this.widget,
    required this.nextCallback,
  }) : super(key: key);

  final int currentZekr;
  final ZekrScreen widget;
  final Function()? previousCallback;
  final Function()? nextCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: previousCallback,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: CircleAvatar(
              maxRadius: 33.r,
              backgroundColor: AppColors.green,
              child: Transform.rotate(
                angle: pi,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 38.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Container(
              height: 70.h,
              child: Center(
                child: Text(
                  "${currentZekr + 1}/${widget.zekrData.length}",
                  style: TextStyle(fontSize: 16.sp, color: AppColors.green),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: AppColors.green),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: nextCallback,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: CircleAvatar(
              maxRadius: 33.r,
              backgroundColor: AppColors.green,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 38.r,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReadCounter extends StatelessWidget {
  const ReadCounter({
    Key? key,
    required this.widget,
    required this.currentZekr,
    required this.readCallback,
    required this.resetCallback,
  }) : super(key: key);

  final ZekrScreen widget;
  final Function()? resetCallback;
  final Function()? readCallback;

  final int currentZekr;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16.r),
        ),
        color: AppColors.blue,
      ),
      height: 70.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: readCallback,
                  splashColor: AppColors.blue,
                  child: Container(
                    height: 50.h,
                    width: 100.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(16.r)),
                    child: Text(
                      LocaleKeys.read.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 50.w),
              child: CustomPaint(
                painter: CirclePercentage(
                  widget.zekrData[currentZekr].done /
                      widget.zekrData[currentZekr].count,
                  '${widget.zekrData[currentZekr].done}/${widget.zekrData[currentZekr].count}',
                ),
                size: Size(60.r, 60.r),
              ),
            ),
            ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: resetCallback,
                  child: CircleAvatar(
                    child: Image.asset(R.ASSETS_IMAGES_REPLAY_PNG),
                    maxRadius: 30.r,
                    backgroundColor: AppColors.yellow,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ZekrTabView extends StatelessWidget {
  const ZekrTabView({
    Key? key,
    required this.widget,
    required this.currentZekr,
  }) : super(key: key);

  final ZekrScreen widget;
  final int currentZekr;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: TabBarView(
          children: [
            SingleChildScrollView(
              child: Text(
                widget.zekrData[currentZekr].zekr,
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
            Text(
              widget.zekrData[currentZekr].benefits,
              style: TextStyle(fontSize: 15.sp),
            ),
            Text(
              widget.zekrData[currentZekr].ta7qeeq,
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class ZekrTabs extends StatelessWidget {
  const ZekrTabs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 0.8.sw,
      child: AppTabBar(
        isScrollable: false,
        tabs: [
          Text(LocaleKeys.zekr.tr()),
          Text(LocaleKeys.benefit.tr()),
          Text(LocaleKeys.ta7qeeq.tr()),
        ],
      ),
    );
  }
}

class CirclePercentage extends CustomPainter {
  final double percentage;
  final String data;

  const CirclePercentage(this.percentage, this.data);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // canvas.translate(-25.w, 0);
    final percentColor = percentage >= 1 ? AppColors.green : Colors.white;
    paint.color = percentColor.withOpacity(0.26);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: 30.r),
        pi,
        2 * pi,
        true,
        paint);
    paint.color = percentColor;
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: 30.r),
        pi * 1.5,
        2 * pi * percentage,
        true,
        paint);
    paint.color = AppColors.blue;
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: 25.r),
        pi / 2,
        2 * pi,
        true,
        paint);
    final tp = TextPainter(
        textAlign: TextAlign.left, textDirection: TextDirection.rtl);
    tp.text = TextSpan(
      text: data,
      style: TextStyle(color: Colors.white, fontSize: 12.sp),
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(
        size.width / 2 - tp.width / 2,
        size.height / 2 - tp.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
