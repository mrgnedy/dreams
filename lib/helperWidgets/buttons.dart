import 'package:dreams/const/colors.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Result state;
  const GradientButton(
      {Key? key,
      required this.onTap,
      required this.title,
      this.state = const Result.init()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: (state is LoadingResult)
          ? const CircularProgressIndicator()
          : Container(
              height: 0.07.sh,
              // width: 0.8.sw,
              //  decoration: ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.blue,
                    AppColors.green,
                  ],
                  stops: [
                    0.5,
                    0.9,
                  ],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
              ),
              child: Center(
                child:
                    Text("$title", style: const TextStyle(color: Colors.white)),
              ),
            ),
    );
  }
}

class BorderButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  const BorderButton({Key? key, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 0.07.sh,
        // width: 0.8.sw,
        //  decoration: ,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: AppColors.blue,
            )),
        child: Center(
          child: Text("$title"),
        ),
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color color;
  const SimpleButton(
      {Key? key,
      required this.onTap,
      required this.title,
      this.color = AppColors.green})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 0.07.sh,
        // width: 0.8.sw,
        //  decoration: ,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: color),
        child: Center(
          child: Text("$title", style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
