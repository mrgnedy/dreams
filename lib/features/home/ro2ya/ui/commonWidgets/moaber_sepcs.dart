import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../const/colors.dart';

class MoaberSpecs extends StatelessWidget {
  final MoaberData moaberData;
  MoaberSpecs({
    Key? key,
    required this.moaberData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(R.ASSETS_IMAGES_CUP_PNG),
              Text(
                'خبرة ${moaberData.experience_years} أعوام',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.green,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.0.w),
            child: Row(
              children: [
                Image.asset(R.ASSETS_IMAGES_FLASH_PNG),
                Text(
                  'الرد خلال يوم',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
