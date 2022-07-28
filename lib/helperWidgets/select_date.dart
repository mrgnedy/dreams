import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/colors.dart';
import '../const/resource.dart';

class SelectDate extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;

  final String hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool isPassowrd;
  final String? Function(String?)? validator;
  const SelectDate({
    Key? key,
    this.leading,
    this.trailing,
    required this.hint,
    this.controller,
    this.isPassowrd = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SelectDate> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<SelectDate> {
  bool isPassowrd = false;
  @override
  void initState() {
    super.initState();
    isPassowrd = widget.isPassowrd;
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextFormField(
        obscureText: isPassowrd,
        validator: widget.validator,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black
        ),
        decoration: InputDecoration(
          fillColor: AppColors.lightGrey,
          prefixIcon: widget.leading,
          suffixIcon: widget.isPassowrd
              ? InkWell(
                  onTap: () => setState(() => isPassowrd = !isPassowrd),
                  child: Image.asset(R.ASSETS_IMAGES_OBSECURE_PNG),
                )
              : widget.trailing,
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
