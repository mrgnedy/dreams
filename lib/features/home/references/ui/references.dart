// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
// import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:supercharged/supercharged.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({Key? key}) : super(key: key);
  final docList = const [
    CardItem(
        name: 'الرؤيا وما يتعلق بها',
        subTitle: 'الجار الله',
        icon: R.ASSETS_DOCS_1_PDF),
    // CardItem(
    //     name: 'أسئلة حول الرؤى وعامة',
    //     subTitle: 'محمد العتيبي',
    //     icon: R.ASSETS_DOCS_2_PDF),
    CardItem(
        name: 'كتاب الجامع - باب الرؤيا',
        subTitle: 'الإمام أحمد',
        icon: R.ASSETS_DOCS_2_PDF),
    // CardItem(
    //     name: 'القواعد الحسنى في تأويل الرؤى',
    //     subTitle: 'عبدالله السدحان',
    //     icon: R.ASSETS_DOCS_3_PDF),
    CardItem(
        name: 'مختصر تفسير الأحلام',
        subTitle: 'ابن سيرين',
        icon: R.ASSETS_DOCS_3_PDF),
    // CardItem(
    //     name: 'نزهة الرؤى في علم الرؤى',
    //     subTitle: 'علي بن سعد الغامدي',
    //     icon: R.ASSETS_DOCS_4_PDF),
    CardItem(
        name: 'مفاتيح تفسير الرؤى والأحلام',
        subTitle: 'ابن القيـّـم',
        icon: R.ASSETS_DOCS_4_PDF),
    // CardItem(
    //     name: 'رموز الرؤى',
    //     subTitle: 'محمد العتيبي',
    //     icon: R.ASSETS_DOCS_5_PDF),
  ];
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: LocaleKeys.tafseerRefs.tr(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w).copyWith(bottom: 8.w),
          child: Column(
            children: [
              Text(
                'يرجى ملاحظة أن تعبير الرؤيا لا تتعلق بالقراءة في كتب التعبير بتاتا وقد صنف ابن سرور كتابه (قواعد في تعبير الرؤيا) وهو حكايته للدلالات التي يُتوصل بها إلى التعبير للرؤيا .. ومن فتح الله عليه - في الأصل - هو الذي يستطيع ربط أجزاء الرؤيا واستخراج المغازي التي تخفى على باقي الناس ... ولكن تعبير الرؤيا علم لا يمكن اكتسابه بالاجتهاد أبدا .. والكتب إنما هي لتعلم الطرق التي تعين على فك الرموز في من هو موهوب - أصلا',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
              ...docList.map((e) => ReferenceCard(docData: e)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReferenceCard extends StatelessWidget {
  final CardItem docData;
  ReferenceCard({
    Key? key,
    required this.docData,
  }) : super(key: key);
  // late PdfController pdfCtlr;
  @override
  Widget build(BuildContext context) {
    return Text("Not supported on windows for now :(");
    // return Padding(
    //   padding: EdgeInsets.only(top: 8.0.h),
    //   child: GestureDetector(
    //     onTap: () async {
    //       // final pdf = PdfDocument.openAsset(docData.icon!);
    //       pdfCtlr = PdfController(document: pdf);
    //       await MainScaffold(
    //         title: LocaleKeys.tafseerRefs.tr(),
    //         trailing: CircleAvatar(
    //           // maxRadius: 20.r,
    //           backgroundColor: Colors.white.withOpacity(0.3),
    //           child: ClipOval(
    //             clipBehavior: Clip.hardEdge,
    //             child: Material(
    //               color: Colors.transparent,
    //               child: InkWell(
    //                 onTap: () async {
    //                   final path = await getTemporaryDirectory();
    //                   final doc = await rootBundle.load(docData.icon!);
    //                   final file = File('${path.path}/${docData.name}}.pdf');
    //                   await file.writeAsBytes(doc.buffer.asUint8List());
    //                   await Share.shareFiles([file.path],
    //                       sharePositionOrigin: Rect.zero);
    //                 },
    //                 child: Padding(
    //                   padding: EdgeInsets.all(5.0.w),
    //                   child: Icon(
    //                     Icons.share,
    //                     size: 25.r,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         body: PdfView(
    //           controller: pdfCtlr,
    //           scrollDirection: Axis.vertical,
    //         ),
    //       ).push(context);
    //       pdfCtlr.dispose();
    //     },
    //     child: Container(
    //       decoration: BoxDecoration(
    //           color: AppColors.blue.withOpacity(0.06),
    //           borderRadius: BorderRadius.circular(16)),
    //       child: Padding(
    //         padding: EdgeInsets.all(20.r),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               child: Container(
    //                 foregroundDecoration: const BoxDecoration(
    //                   image: DecorationImage(
    //                     alignment: AlignmentDirectional.bottomStart,
    //                     image: AssetImage(
    //                       R.ASSETS_IMAGES_RED_DOC_PNG,
    //                     ),
    //                   ),
    //                 ),
    //                 child: Image.asset(
    //                   R.ASSETS_IMAGES_ZEKR_PLACEHOLDER_PNG,
    //                 ),
    //               ),
    //             ),
    //             Expanded(
    //               flex: 3,
    //               child: Padding(
    //                 padding: EdgeInsetsDirectional.only(start: 16.0.w),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       docData.name!,
    //                       style: TextStyle(
    //                           fontSize: 16.sp, fontWeight: FontWeight.bold),
    //                     ),
    //                     Text(
    //                       docData.subTitle!,
    //                       style: TextStyle(fontSize: 12.sp, color: Colors.grey),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Image.asset(R.ASSETS_IMAGES_DOC_PNG)
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
