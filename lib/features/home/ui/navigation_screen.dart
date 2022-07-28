import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/azkar/ui/azkar_list.dart';
import 'package:dreams/features/home/ro2ya/ui/my_ro2yas.dart';
import 'package:dreams/features/home/ui/home.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supercharged/supercharged.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navItems = [
    CardItem(
        name: 'الرئيسية',
        icon: R.ASSETS_IMAGES_MAIN_NAV_PNG,
        // icon: R.ASSETS_IMAGES_MAIN_NAV_PNG,
        onPressed: () {}),
    CardItem(
        name: 'سجل الرؤى',
        icon: R.ASSETS_IMAGES_RECORDS_NAV_PNG,
        // icon: R.ASSETS_IMAGES_RECORDS_NAV_PNG,
        onPressed: () {}),
    CardItem(
        name: '',
        // icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,
        icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,
        onPressed: () {}),
    CardItem(
        name: 'الإشعارات',
        // icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,

        icon: R.ASSETS_IMAGES_NOTIFICATION_NAV_PNG,
        onPressed: () {}),
    CardItem(
        name: 'حسابي', icon: R.ASSETS_IMAGES_PROFILE_NAV_PNG, onPressed: () {}),
  ];
  final pages =   [
    HomeScreen(),
    const MyRo2yas(),
    HomeScreen(),
    HomeScreen(),
    FlutterLogo(),
  ];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 100.r,
          child: Image.asset(
            R.ASSETS_IMAGES_TAABER_PNG,
            fit: BoxFit.contain,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (i) {
            setState(() {
              currentPage = i;
            });
          },
          showUnselectedLabels: true,
          items: navItems
              .mapIndexedSC((e, index) => BottomNavigationBarItem(
                  icon: e.name!.isEmpty
                      ? Container()
                      : Image.asset(e.icon!.replaceAll(
                          '.png', currentPage == index ? '_filled.png' : ".png")),
                  label: e.name!))
              .toList(),
        ),
        body: pages[currentPage],
      ),
    );
  }
}
