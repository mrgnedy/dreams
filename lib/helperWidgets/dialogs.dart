import 'package:dreams/const/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDialog extends StatelessWidget {
  final String? msg;
  static show(BuildContext context, [String? msg]) => showDialog(
        context: context,
        builder: (context) => IntrinsicHeight(
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: SuccessDialog(msg: msg),
          ),
        ),
      );
  const SuccessDialog({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(R.ASSETS_IMAGES_GRAD_CHECK_PNG),
          Padding(
            padding:   EdgeInsets.only(top: 25.0.h),
            child:   Text(
              "تم إرسال كود إسترجاع كلمة المرور  بنجاح إلى\ninfo@gmail.com",
              textAlign: TextAlign.center,style: TextStyle(fontSize: 15.sp)
            ),
          )
        ],
      ),
    );
  }
}
