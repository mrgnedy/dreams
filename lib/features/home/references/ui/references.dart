import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:pdfx/pdfx.dart';

import 'dart:io';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:supercharged/supercharged.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: LocaleKeys.tafseerRefs.tr(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w).copyWith(bottom: 8.w),
          child: Column(
              children: 1.rangeTo(20).map((e) => ReferenceCard()).toList()),
        ),
      ),
    );
  }
}

class ReferenceCard extends StatelessWidget {
  ReferenceCard({
    Key? key,
  }) : super(key: key);
  late PdfController pdfCtlr;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h),
      child: GestureDetector(
        onTap: () async {
          final pdf = PdfDocument.openAsset(R.ASSETS_DOCS_PDF_TEST_PDF);
          pdfCtlr = PdfController(document: pdf);
          await MainScaffold(title: 'مرجع في التفسير' , body: PdfView(controller: pdfCtlr)).push(context);
          pdfCtlr.dispose();
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    foregroundDecoration: const BoxDecoration(
                      image: DecorationImage(
                        alignment: AlignmentDirectional.bottomStart,
                        image: AssetImage(
                          R.ASSETS_IMAGES_RED_DOC_PNG,
                        ),
                      ),
                    ),
                    child: Image.asset(
                      R.ASSETS_IMAGES_ZEKR_PLACEHOLDER_PNG,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أسئلة حول الرؤى عامة',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'نبذة مختصرة عن المرجع تظهر هنا معبرةعنا محتواها',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(R.ASSETS_IMAGES_DOC_PNG)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
