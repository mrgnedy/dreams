import 'package:dreams/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorWidget extends StatelessWidget {
  final String error;
  final Function()? onError;
  const AppErrorWidget({
    Key? key,
    required this.error,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onError,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error, style: TextStyle(fontSize: 16.sp, color: Colors.red),),
            Icon(Icons.refresh, size: 60.r, color: AppColors.blue,),
            Text("إضغط لإعادة المحاولة", style: TextStyle(fontSize: 12.sp, color: AppColors.blue),),
          ],
        ),
      ),
    );
  }
}
