// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/resource.dart';

class SuccessDialog extends StatelessWidget {
  final String msg;
  final bool isSuccess;
  static show(BuildContext context, String msg, {bool isSuccess = true}) =>
      showDialog(
        context: context,
        builder: (context) => IntrinsicHeight(
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: SuccessDialog(
              msg: msg,
              isSuccess: isSuccess,
            ),
          ),
        ),
      );
  const SuccessDialog({
    Key? key,
    required this.msg,
    this.isSuccess = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSuccess
              ? Image.asset(R.ASSETS_IMAGES_GRAD_CHECK_PNG)
              : Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 100.h,
                ),
          Padding(
            padding: EdgeInsets.only(top: 25.0.h),
            child: Text(msg,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15.sp)),
          )
        ],
      ),
    );
  }
}
