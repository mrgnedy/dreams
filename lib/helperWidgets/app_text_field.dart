import 'dart:developer';

import 'package:dreams/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supercharged/supercharged.dart';

import '../const/colors.dart';
import '../const/resource.dart';

enum TextType {
  text,
  password,
  date,
  phone,
}

class AppTextFormField extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final TextType? textType;
  final String hint;
  final String initValue;
  final int? maxLines;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  final String? Function(String?)? validator;
  const AppTextFormField({
    Key? key,
    this.leading,
    this.trailing,
    required this.hint,
    this.controller,
    this.validator,
    this.initValue = '',
    this.maxLines = 1,
    required this.onChanged,
    this.textType = TextType.text,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool isPassowrd = false;
  final TextEditingController ctrler = TextEditingController();
  Widget? trailing;
  Widget? leading;
  String? Function(String?) validator = Validators.generalValidator;
  TextInputType? inputType;
  @override
  void initState() {
    super.initState();
    leading = widget.leading;
    if (widget.initValue.isNotEmpty) ctrler.text = widget.initValue;
    log("${widget.textType}");
    switch (widget.textType) {
      case null:
      case TextType.phone:
        trailing = widget.trailing;
        inputType = TextInputType.phone;
        leading = leading ?? Image.asset(R.ASSETS_IMAGES_PHONE_PNG);
        validator = Validators.phone;
        break;
      case TextType.text:
        trailing = widget.trailing;

        break;
      case TextType.password:
        isPassowrd = widget.textType == TextType.password;
        validator = Validators.passowrd;
        leading = leading ?? Image.asset(R.ASSETS_IMAGES_PASSWORD_PNG);
        trailing = InkWell(
          onTap: () => setState(() => isPassowrd = !isPassowrd),
          child: Image.asset(R.ASSETS_IMAGES_OBSECURE_PNG),
        );

        break;
      case TextType.date:
        inputType = TextInputType.datetime;
        validator = Validators.date;
        leading = leading ?? Image.asset(R.ASSETS_IMAGES_CALENDAR_PNG);
        trailing = InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(1.days),
              firstDate: DateTime(1900),
              lastDate: DateTime.now().subtract(1.days),
            );
            if (date == null) return;
            setState(() {
              ctrler.text =
                  date.toString().split(' ').first.replaceAll('/', '-');
              widget.onChanged?.call(ctrler.text);
            });
          },
          child: Image.asset(R.ASSETS_IMAGES_DATE_PNG),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextFormField(
        controller: ctrler,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: widget.maxLines,
        obscureText: isPassowrd,
        validator: widget.validator ?? validator,
        onChanged: widget.onChanged,
        keyboardType: inputType,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.red,
          prefixIcon: leading,
          prefixIconConstraints:
              BoxConstraints.expand(height: 48.h, width: 48.h),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: trailing,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hint,
          contentPadding: const EdgeInsets.all(8),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
