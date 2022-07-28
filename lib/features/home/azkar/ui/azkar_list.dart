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
    final data = await rootBundle.loadString(R.ASSETS_DOCS_AZKAR_CSV);

    setState(() {
      fields = csv.CsvCodec().decoder.convert(data)..removeAt(0);
      categorize();
    });
  }

  Map<String, List<ZekrData>> azkar = {};
  categorize() {
    for (var element in fields) {
      if (element[1].toString().isEmpty) continue;
      final zekr = ZekrData(
        zekr: element[3],
        count: int.tryParse(element[6].toString()) ?? 1,
        benefits: element[7],
        ta7qeeq: element[8],
      );
      if (azkar['${element[1]}'] != null) {
        azkar['${element[1]}']!.add(zekr);
      } else {
        azkar['${element[1]}'] = [zekr];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(azkar['أذكار المساء']?.first.toString() ?? '');
    return MainScaffold(
      title: LocaleKeys.azkarRo2ya.tr(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AzkarListWithTitle(
                azkar: azkar.entries.take(2), title: LocaleKeys.mornEvenAzkar),
            AzkarListWithTitle(
                azkar: azkar.entries.skip(2), title: LocaleKeys.variousAzkar),
          ],
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
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              azkar.length,
              (index) {
                final zekrItem = azkar.elementAt(index);
                return InkWell(
                  onTap: () => ZekrScreen(
                    zekrData: zekrItem.value,
                    zekrCategory: zekrItem.key,
                  ).push(context),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8, end: 8),
                    child: Container(
                      height: 200.h,
                      width: 170.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: Image.asset(
                                  R.ASSETS_IMAGES_ZEKR_PLACEHOLDER_PNG)),
                          Text(
                            zekrItem.key,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            "${zekrItem.value.length}",
                            style: TextStyle(
                                fontSize: 14.sp, color: AppColors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ZekrData {
  final String zekr;
  final int count;
  final int done;
  final String benefits;
  final String ta7qeeq;

  ZekrData(
      {required this.zekr,
      required this.count,
      this.done = 0,
      required this.benefits,
      required this.ta7qeeq});

  ZekrData copyWith({
    String? zekr,
    int? count,
    int? done,
    String? benefits,
    String? ta7qeeq,
  }) {
    return ZekrData(
      zekr: zekr ?? this.zekr,
      count: count ?? this.count,
      done: done ?? this.done,
      benefits: benefits ?? this.benefits,
      ta7qeeq: ta7qeeq ?? this.ta7qeeq,
    );
  }
}
