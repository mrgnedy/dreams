
import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRadioGroupWithTitle extends StatefulWidget {
  final List items;
  final String title;
  const AppRadioGroupWithTitle({
    Key? key,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  State<AppRadioGroupWithTitle> createState() => _AppRadioGroupWithTitleState();
}

class _AppRadioGroupWithTitleState extends State<AppRadioGroupWithTitle> {
  int? groupValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 15.sp),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: List.generate(
                widget.items.length,
                (index) => GestureDetector(
                  onTap: () => setState(() => groupValue = index),
                  child: AppRadioGroup(
                    value: index,
                    text: widget.items[index],
                    groupValue: groupValue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppRadioGroup extends StatelessWidget {
  final int value;
  final int? groupValue;
  final String text;
  const AppRadioGroup({
    Key? key,
    required this.value,
    required this.text,
    this.groupValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, right: 15.w),
          child: value == groupValue
              ? const Image(
                  image: AssetImage(R.ASSETS_IMAGES_CHECK_BLUE_PNG)) //1479
              : Container(
                  height: 24.h,
                  width: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.blue),
                  ),
                ),
        ),
        Text(text)
      ],
    );
  }
}
