import 'package:dreams/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTabBar extends StatelessWidget {
  final List<Widget> tabs;
  const AppTabBar({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        labelStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.blue, AppColors.green],
              stops: [0.5, 0.9],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ),
            borderRadius: BorderRadius.circular(100)),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: tabs,
      ),
    );
  }
}
