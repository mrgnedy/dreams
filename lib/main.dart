import 'dart:ui';

import 'package:dreams/const/codegen_loader.g.dart';
import 'package:dreams/const/colors.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';

final di = GetIt.I;
void main() {
  runApp(MyApp());
  di.registerLazySingleton(() => AuthCubit());
}

class MyApp extends StatefulWidget {
  Key _key = UniqueKey();
  static restart(BuildContext context) {
    context.findRootAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  restartApp() {
    setState(() {
      widget._key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: 'assets/langs',
      supportedLocales: const [Locale('ar')],
      startLocale: const Locale('ar'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      fallbackLocale: const Locale('ar'),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext context, Widget? child) => MaterialApp(
          key: widget._key,
          localizationsDelegates: context.localizationDelegates,
          locale: const Locale('ar'),
          title: 'Azkar',
          supportedLocales: [context.locale],
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "RB"),
          home: StreamBuilder<Object>(
            builder: (context, snapshot) {
              return const SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}