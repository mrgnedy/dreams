import 'dart:developer';
import 'dart:ui';

import 'package:dreams/const/codegen_loader.g.dart';
import 'package:dreams/const/colors.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/locale_cubit.dart';
import 'package:dreams/features/notfications/state/notification_cubit.dart';
import 'package:dreams/features/notfications/ui/notification_screen.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/splash.dart';
import 'package:dreams/utils/fcm_helper.dart';
import 'package:dreams/utils/local_notification_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';

import 'features/home/ui/navigation_screen.dart';

final di = GetIt.I;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocalNotificationHelper.init();
  di.registerLazySingleton(() => AuthCubit());
  di.registerLazySingleton(() => LocaleCubit());
  FCMHelper.config(
    onForegroundMsg: (p0, p1) {
      log("onMsg: ${p0.toMap()}");
      LocalNotificationHelper.createLocalNotification(p0);
    },
    onBackgroundMsg: (p0, p1) {
      log("onBack: ${p0.toMap()}");
      Future.delayed(500.ms, () {
        const NavigationScreen().pushAndRemoveAll(
            FCMHelper.navState.currentState!.context,
            isMaterial: false);
        const NotificationScreen()
            .push(FCMHelper.navState.currentState!.context);
      });
    },
    onTerminatedMsg: (p0, p1) {
      log("onTerminated: ${p0.toMap()}");
      Future.delayed(500.ms, () {
        const page = NotificationScreen();
        page.push(p1);
      });
    },
    // onTokenObtained: (token) => di<AuthCubit>().updateDeviceToken(token),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
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
      supportedLocales: const [Locale('ar'), Locale('en')],
      startLocale: const Locale('ar'),
      useOnlyLangCode: true,
      saveLocale: true,
      assetLoader: const CodegenLoader(),
      fallbackLocale: const Locale('ar'),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext context, Widget? child) => StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              Size size = MediaQuery.of(context).size;
              print(context.locale);
              di<LocaleCubit>().updateLocale(context.locale);
              return MaterialApp(
                key: widget._key,
                // onGenerateRoute: (route){
                //   log('Name: ${route.name}');
                //   // return route ;
                // },
                navigatorKey: FCMHelper.navState,
                localizationsDelegates: context.localizationDelegates,
                locale: context.appLocale,
                title: 'Azkar',
                supportedLocales: context.supportedLocales,
                theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "RB"),
                home: Builder(
                  builder: (context) {
                    return const SplashScreen();
                  },
                ),
              );
            }),
      ),
    );
  }
}
