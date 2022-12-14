import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/colors.dart';

class MainScaffold extends StatelessWidget {
  final String? title;
  final Widget? customHeader;
  final Widget body;
  final double gradientAreaHeight;
  final Widget? leading;
  final Widget? trailing;
  final bool isAppBarFixed;
  const MainScaffold(
      {Key? key,
      this.title,
      required this.body,
      this.customHeader,
      this.gradientAreaHeight = 130,
      this.leading,
      this.isAppBarFixed = false,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: 1.sh,
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              // alignment: Alignment.topCenter,
              height: gradientAreaHeight.h,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  AppColors.blue,
                  AppColors.green,
                ],
                stops: [
                  0.5,
                  0.9,
                ],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              )),
              child: Row(
                children: [
                  Expanded(
                    child:
                        leading ?? AppBackButton(isAppBarFixed: isAppBarFixed),
                  ),
                  if (title != null && title!.isNotEmpty)
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            title ?? '',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: trailing ?? Container(),
                  ),
                ],
              ),
            ),
            // else
            Positioned.fill(
              top: gradientAreaHeight.h - 16,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: isAppBarFixed ? Container() : body,
              ),
            ),
            if (isAppBarFixed) body,
          ],
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    Key? key,
    required this.isAppBarFixed,
  }) : super(key: key);

  final bool isAppBarFixed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !ModalRoute.of(context)!.isFirst && !isAppBarFixed,
      child: Align(
        alignment: AlignmentDirectional.lerp(AlignmentDirectional.centerStart,
            AlignmentDirectional.center, 0.5)!,
        child: CircleAvatar(
          // maxRadius: 20.r,
          radius: 25.r,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: InkWell(
            onTap: context.pop,
            child: CircleAvatar(
              // clipBehavior: Clip.hardEdge,
              backgroundColor: Colors.transparent,
              child: Material(
                color: Colors.transparent,
                child: Transform.rotate(
                  angle: pi * (1 - Directionality.of(context).index),
                  alignment: Alignment.center,
                  child:   FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 30.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
