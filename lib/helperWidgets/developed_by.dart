import 'package:dreams/const/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';

class DevelopedBy extends StatelessWidget {
  const DevelopedBy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(recognizer: TapGestureRecognizer()..onTap = () {},
            //     try {
            //     //   launch(Urls.WEBSITE);
            //     // } catch (e) {}
            //   },
            children: [
              TextSpan(
                text: "Powered by\n",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.normal,
                    height: 0.5),
              ),
              TextSpan(
                text: "GulfTerminal.com",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.7),
              ),
            ]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
