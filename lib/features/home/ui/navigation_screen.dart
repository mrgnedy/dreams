import 'dart:async';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/account/ui/profile_screen.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/azkar/ui/azkar_list.dart';
import 'package:dreams/features/home/references/ui/references.dart';
import 'package:dreams/features/home/ro2ya/state/my_ro2yas_cubit.dart';
import 'package:dreams/features/home/ro2ya/ui/mo3aberen_list.dart';
import 'package:dreams/features/home/ro2ya/ui/my_ro2yas.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/features/notfications/state/notification_cubit.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supercharged/supercharged.dart';

import '../../notfications/ui/notification_screen.dart';
import '../ro2ya/state/mo3beren_cubit.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navItems = [
    CardItem(
        name: LocaleKeys.home.tr(),
        icon: R.ASSETS_IMAGES_MAIN_NAV_PNG,
        // icon: R.ASSETS_IMAGES_MAIN_NAV_PNG,
        onPressed: () {}),
    CardItem(
        name: LocaleKeys.myDreams.tr(),
        icon: R.ASSETS_IMAGES_RECORDS_NAV_PNG,
        // icon: R.ASSETS_IMAGES_RECORDS_NAV_PNG,
        onPressed: () {}),
    if (!isProvider())
      CardItem(
          name: '',
          // icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,
          icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,
          onPressed: () {}),
    CardItem(
        name: LocaleKeys.notifications.tr(),
        // icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,

        icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,
        onPressed: () {}),
    CardItem(
        name: LocaleKeys.myProfile.tr(),
        icon: R.ASSETS_IMAGES_PROFILE_NAV_PNG,
        onPressed: () {}),
  ];
  // int currentPage = 0;
  HomeNavigationCubit cubit = HomeNavigationCubit();

  final pages = [
    HomeScreen(),
    const MyRo2yas(),
    if (!isProvider()) HomeScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];
  int backCount = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyRo2yasCubit>(
          create: (BuildContext context) => MyRo2yasCubit(),
        ),
        BlocProvider<NotificationCubit>(
          create: (BuildContext context) =>
              NotificationCubit()..getNotificion(),
        ),
      ],
      child: WillPopScope(
        onWillPop: () {
          Future.delayed(2.s, () => backCount = 0);
          if (backCount >= 1) {
            SystemNavigator.pop();
          } else {
            Fluttertoast.showToast(msg: 'اضغط مرة اخرى للخروج');
          }
          backCount++;
          return Future.value(false);
        },
        child: BlocBuilder<HomeNavigationCubit, Result>(
          bloc: cubit,
          builder: (context, state) {
            final currentPage = state.getSuccessData() ?? 0;
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: isProvider()
                    ? Container()
                    : SizedBox(
                        height: 100.r,
                        child: GestureDetector(
                          onTap: () {
                            final moaberenCubit = MoaberenCubit()
                              ..getMoaberenList();
                            (BlocProvider.value(
                              value: moaberenCubit,
                              child: MoaberenListScreen(
                                moaberenCubit: moaberenCubit,
                              ),
                            )).push(context);
                          },
                          child: Image.asset(
                            R.ASSETS_IMAGES_TAABER_PNG,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: (i) {
                    // setState(() {
                    cubit.changeScreen(i);
                    // currentPage = i;
                    navItems[i].onPressed?.call();
                    // });
                  },
                  currentIndex: currentPage,
                  showUnselectedLabels: true,
                  items: navItems
                      .mapIndexedSC((e, index) => BottomNavigationBarItem(
                          icon: e.name!.isEmpty
                              ? Container()
                              : Image.asset(e.icon!.replaceAll(
                                  '.png',
                                  currentPage == index
                                      ? '_filled.png'
                                      : ".png")),
                          label: e.name!))
                      .toList(),
                ),
                body: pages[currentPage]);
          },
        ),
      ),
    );
  }
}

class HomeNavigationCubit extends Cubit<Result> {
  HomeNavigationCubit() : super(const Result.init());

  changeScreen(int index) {
    emit(Result.success(index));
  }
}
