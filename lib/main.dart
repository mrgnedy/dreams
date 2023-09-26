// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:ui';

import 'package:dreams/const/codegen_loader.g.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/locale_cubit.dart';
import 'package:dreams/features/notfications/ui/notification_screen.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/splash.dart';
import 'package:dreams/utils/fcm_helper.dart';
import 'package:dreams/utils/local_notification_helper.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'features/home/ui/navigation_screen.dart';

final di = GetIt.I;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
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

class ContinousScrollListOfScrollables extends StatefulWidget {
  final List<Widget> scrollableWidgets;
  const ContinousScrollListOfScrollables(
      {Key? key, this.scrollableWidgets = const []})
      : super(key: key);

  @override
  State<ContinousScrollListOfScrollables> createState() =>
      _ContinousScrollListOfScrollablesState();
}

class _ContinousScrollListOfScrollablesState
    extends State<ContinousScrollListOfScrollables> {
  List<WidgetWithControllers> widgetsWithControllers = [];

  @override
  void initState() {
    super.initState();
    widgetsWithControllers =
        widget.scrollableWidgets.map((e) => WidgetWithControllers(e)).toList();
  }

  @override
  void dispose() {
    for (var element in widgetsWithControllers) {
      element.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        controller: mainCtrler,
        child: Column(
          children: [
            ...List.generate(widgetsWithControllers.length, (index) {
              final currentCtrler = widgetsWithControllers[index];
              return SizedBox(
                height: 500.h,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: currentCtrler.controller,
                        physics: currentCtrler.scrollPhysics,
                        child: GestureDetector(
                            onVerticalDragEnd: (details) {
                              final x = details.primaryVelocity;
                              // log("Velo: $x");
                              onDrag((x?.sign ?? -1) * 50,
                                  currentCtrler.controller, true);
                            },
                            onVerticalDragUpdate: (details) {
                              final dY = details.delta.dy;
                              onDrag(dY, currentCtrler.controller);
                            },
                            child: currentCtrler.child),
                      ),
                    ),
                    Divider()
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  final mainCtrler = ScrollController();

  scrollCtrlerBy(ScrollController ctrler, double offset,
      [bool animate = false]) {
    if (animate) {
      ctrler.animateTo(
          (ctrler.offset - offset).clamp(0, ctrler.position.maxScrollExtent),
          duration: 200.ms,
          curve: Curves.decelerate);
    } else {
      ctrler.jumpTo(
          (ctrler.offset - offset).clamp(0, ctrler.position.maxScrollExtent));
    }
  }

  onDrag(double dY, ScrollController currentCtrler, [bool animate = false]) {
    log(dY.toString());
    bool atTopEdge = currentCtrler.position.atEdge && currentCtrler.offset < 1;
    bool atBottomEdge =
        currentCtrler.position.atEdge && currentCtrler.offset > 1;

    if (dY.isNegative) {
      //  Scrolling down
      if (atBottomEdge) {
        scrollCtrlerBy(mainCtrler, dY, animate);
      } else {
        scrollCtrlerBy(currentCtrler, dY, animate);
      }
    } else {
      // Scrolling up
      if (atTopEdge) {
        scrollCtrlerBy(mainCtrler, dY, animate);
      } else {
        scrollCtrlerBy(currentCtrler, dY, animate);
      }
    }
  }
}

class WidgetWithControllers {
  final Widget child;
  final ScrollController controller;
  final ScrollPhysics scrollPhysics;

  WidgetWithControllers(this.child)
      : scrollPhysics = const ClampingScrollPhysics(),
        controller = ScrollController();
}
