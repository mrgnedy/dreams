import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart' as csv;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/features/home/azkar/ui/zekr_screen.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:supercharged/supercharged.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCSV();
  }

  late List<List<dynamic>> fields;
  loadCSV() async {
    final data = await rootBundle.loadString(R.ASSETS_DOCS_AZKARV2_CSV);

    setState(() {
      fields = csv.CsvCodec().decoder.convert(data)..removeAt(0);
      categorize();
    });
  }

  categorize() {
    List<ZekrData> azkar = [];
    for (var element in fields) {
      if (element[0].toString().isEmpty) continue;
      final zekr = ZekrData(
        category: element[context.isAr ? 0 : 1],
        subCat: element[context.isAr ? 2 : 3],
        zekr: element[context.isAr ? 4 : 5],
        count: int.tryParse(element[7].toString()) ?? 1,
        benefits: element[context.isAr ? 8 : 9],
        ta7qeeq: element[context.isAr ? 10 : 11],
      );
      azkar.add(zekr);
      // if (azkar['${element[2]}'] != null) {
      //   azkar['${element[2]}']!.add(zekr);
      // } else {
      //   azkar['${element[2]}'] = [zekr];
      // }
    }
    zekrCats = azkar.groupBy<String, ZekrData>((element) => element.category);
  }

  Map<String, List<ZekrData>> zekrCats = {};

  @override
  Widget build(BuildContext context) {
    final azkarList = {
      "أذكار الصباح والمساء": zekrCats.entries.take(2),
      "أذكار متنوعة": zekrCats.entries.skip(2),
    };
    return MainScaffold(
      title: LocaleKeys.azkarRo2ya.tr(),
      body: SingleChildScrollView(
        child: Column(
          // alignment: WrapAlignment.center,
          // direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: azkarList.entries
              .map(
                (e) => Padding(
                  padding: EdgeInsets.all(16.0.h),
                  child: AzkarListWithTitle(
                    azkar: e.value,
                    title: e.key,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class AzkarListWithTitle extends StatelessWidget {
  const AzkarListWithTitle({
    Key? key,
    required this.azkar,
    required this.title,
  }) : super(key: key);

  final Iterable<MapEntry<String, List<ZekrData>>> azkar;
  final String title;

  @override
  Widget build(BuildContext context) {
    // final zekrs = azkar.groupBy<String, ZekrData>((element) {
    //   log(element.subCat);
    //   return element.subCat.trim();
    // });
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 0.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title.tr(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: azkar
                  .map(
                    (e) => InkWell(
                      onTap: () => ZekrScreen(
                        zekrData: e.value,
                        zekrCategory: e.key,
                      ).push(context),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.only(top: 8, end: 8),
                        child: Container(
                          height: 220.h,
                          width: 1.sw / 2 - 32.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  R.ASSETS_IMAGES_ZEKR_PLACEHOLDER_PNG,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  e.key,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                              Text(
                                "${e.value.length}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ZekrData {
  final String zekr;
  final String category;
  final String subCat;
  final int count;
  final int done;
  final String benefits;
  final String ta7qeeq;

  ZekrData(
      {required this.zekr,
      required this.count,
      this.done = 0,
      required this.benefits,
      required this.subCat,
      required this.category,
      required this.ta7qeeq});

  ZekrData copyWith({
    String? zekr,
    int? count,
    int? done,
    String? benefits,
    String? ta7qeeq,
    String? category,
    String? subCat,
  }) {
    return ZekrData(
      zekr: zekr ?? this.zekr,
      count: count ?? this.count,
      done: done ?? this.done,
      benefits: benefits ?? this.benefits,
      ta7qeeq: ta7qeeq ?? this.ta7qeeq,
      category: category ?? this.category,
      subCat: subCat ?? this.subCat,
    );
  }
}
