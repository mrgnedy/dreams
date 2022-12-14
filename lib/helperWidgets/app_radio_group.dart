import 'dart:developer';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRadioGroupWithTitle extends StatefulWidget {
  final List items;
  final dynamic value;
  final bool isSingleLine;
  final Function(dynamic s)? onSelected;
  final String title;
  const AppRadioGroupWithTitle({
    Key? key,
    required this.items,
    required this.title,
    this.value,
    this.isSingleLine = false,
    this.onSelected,
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
      child: FormField(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (_) => Validators.chooseValidator(groupValue),
        builder: (FormFieldState<dynamic> field) {
          return widget.isSingleLine
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildChildren(field),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildChildren(field),
                );
        },
      ),
    );
  }

  List<Widget> _buildChildren(FormFieldState<dynamic> field) {
    return [
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
              onTap: () {
                // field.validate();
                setState(() => groupValue = index);
                widget.onSelected?.call(index);
              },
              child: AppRadioGroup(
                value: index,
                text: widget.items[index],
                groupValue: widget.value ?? groupValue,
              ),
            ),
          ),
        ),
      ),
      if (field.hasError)
        Text(
          '${field.errorText}',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.red[700], fontSize: 13),
        )
    ];
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
              ? Image(
                  image: const AssetImage(R.ASSETS_IMAGES_CHECK_BLUE_PNG),
                  height: 24.h,
                  width: 24.h,
                  fit: BoxFit.fill,
                ) //1479
              : Container(
                  height: 24.h,
                  width: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.blue),
                  ),
                ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp),
        )
      ],
    );
  }
}
