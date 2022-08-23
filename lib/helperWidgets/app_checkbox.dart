import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCheckBox extends StatelessWidget {
  final String text;
  final bool isChecked;
  const AppCheckBox({
    Key? key,
    required this.text,
    required this.isChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            height: 24.r,
            width: 24.r,
            child: isChecked
                ? Image.asset(R.ASSETS_IMAGES_CHECK_PNG)
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.green),
                    ),
                  )),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 10.0.h),
          child: Text(text),
        )
      ],
    );
  }
}
