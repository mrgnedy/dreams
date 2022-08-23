// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/resource.dart';

class AppAlertDialog extends StatelessWidget {
  final String msg;
  final bool isSuccess;
  final Function()? okCallback;
  final Function()? cancelCallback;
  final Function()? confirmCallback;
  static show(
    BuildContext context,
    String msg, {
    bool isSuccess = true,
    Function()? okCallback,
    Function()? cancelCallback,
    Function()? confirmCallback,
  }) =>
      showDialog(
        context: context,
        builder: (context) => IntrinsicHeight(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: AppAlertDialog(
              msg: msg,
              isSuccess: isSuccess,
              okCallback: okCallback,
              cancelCallback: cancelCallback,
              confirmCallback: confirmCallback,
            ),
          ),
        ),
      );

  const AppAlertDialog({
    this.okCallback,
    this.cancelCallback,
    this.confirmCallback,
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
          ),
          Row(children: [
            if (okCallback != null)
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0.w).copyWith(bottom: 0),
                child: GradientButton(
                  onTap: okCallback!,
                  title: 'Ok',
                  state: isSuccess ? const Result.init() : const Result.error(''),
                ),
              )),
            if (confirmCallback != null)
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0.w).copyWith(bottom: 0),
                child: GradientButton(
                  state: isSuccess ? const Result.init() : const Result.error(''),
                  onTap: confirmCallback,
                  title: 'Confirm',
                ),
              )),
            if (cancelCallback != null)
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0.w).copyWith(bottom: 0),
                child: BorderButton(
                  onTap: cancelCallback,
                  title: 'Cancel',
                  state: isSuccess ? const Result.init() : const Result.error(''),
                ),
              )),
          ])
        ],
      ),
    );
  }
}
