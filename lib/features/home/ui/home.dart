// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ro2ya/ui/mo3aberen_list.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/features/home/azkar/ui/azkar_list.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final carouselIndex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    final itemsList = [
      CardItem(
          name: LocaleKeys.azkarRo2ya,
          subTitle: LocaleKeys.azkarSubtitle,
          color: Color(0xFF008FCD),
          onPressed: () => AzkarScreen(),
          icon: R.ASSETS_IMAGES_AZKAR_PNG),
      CardItem(
          name: LocaleKeys.ta2weel,
          subTitle: LocaleKeys.ta2weelSubtitle,
          color: Color(0xFF03C491),
          onPressed: ()=> MoaberenListScreen(),
          icon: R.ASSETS_IMAGES_ROYA_PNG),
      CardItem(
          name: LocaleKeys.chats,
          subTitle: LocaleKeys.chatsSubtitle,
          color: Color(0xFFE7C90B),
          onPressed: () {},
          icon: R.ASSETS_IMAGES_CHAT_PNG),
      CardItem(
          name: LocaleKeys.tafseerRefs,
          subTitle: LocaleKeys.tafseerRefsSub,
          color: Color(0xFFE93D4F),
          onPressed: () {},
          icon: R.ASSETS_IMAGES_REFS_PNG),
    ];
    return MainScaffold(
      gradientAreaHeight: 225,
      isAppBarFixed: true,
      body: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: BlocBuilder<AuthCubit, AuthData>(
                bloc: di<AuthCubit>(),
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state.image != null && state.image!.isNotEmpty)
                            Container(
                              height: 45.h,
                              width: 45.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(state.image!),
                                      fit: BoxFit.cover)),
                            ),
                          Padding(
                            padding: EdgeInsets.all(0.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LocaleKeys.welcome.tr(),
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      height: 1.2,
                                      color: Colors.white70),
                                ),
                                if (state.name != null)
                                  Text(
                                    state.name!,
                                    style: TextStyle(
                                        height: 1.5,
                                        fontSize: 16.sp,
                                        color: Colors.white),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          final p = await SharedPreferences.getInstance();
                          await p.clear();
                          await di.reset();
                          di.registerLazySingleton(() => AuthCubit());
                          MyApp.restart(context);
                        },
                        child: Image.asset(
                          R.ASSETS_IMAGES_NOTIFICATION_PNG,
                          height: 45.r,
                          width: 45.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: 1.sw,
              child: CarouselSlider(
                items: [
                  Image.asset(R.ASSETS_IMAGES_CARPUSEL_ITEM_PNG),
                  Image.asset(R.ASSETS_IMAGES_CARPUSEL_ITEM_PNG),
                  Image.asset(R.ASSETS_IMAGES_CARPUSEL_ITEM_PNG),
                ],
                options: CarouselOptions(
                    enableInfiniteScroll: false,
                    height: 150.h,
                    onPageChanged: (i, reason) {
                      carouselIndex.value = i.toInt();
                    },
                    enlargeCenterPage: true,
                    autoPlay: true),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.builder(
                  itemCount: itemsList.length + 1,
                  // itemExtent: 120.h,
                  itemBuilder: ((context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageIndicator(
                            indexNotifier: carouselIndex,
                            indicatorCount: 3,
                          ),
                          Text(
                            LocaleKeys.appSections.tr(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          Text(
                            LocaleKeys.selectSection.tr(),
                            style:
                                TextStyle(fontSize: 13.sp, color: Colors.grey),
                          ),
                        ],
                      );
                    }
                    final item = itemsList[index - 1];
                    return GestureDetector(
                      onTap: () => (item.onPressed!() as Widget).push(context),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.w),
                        decoration: BoxDecoration(
                          color: item.color!.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Image.asset(item.icon!),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name!.tr(),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              item.subTitle!.tr(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: item.color!.withOpacity(0.4),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: item.color,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
      // body: Align(alignment: FractionalOffset(0.5, 0.15), child: Text('sadd')),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final ValueNotifier<int> indexNotifier;
  final int indicatorCount;
  const PageIndicator(
      {Key? key, required this.indexNotifier, this.indicatorCount = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              height: 12.h,
              width: indicatorCount * 32.w,
              child: ValueListenableBuilder<int>(
                valueListenable: indexNotifier,
                builder: (countext, index, child) => ListView.builder(
                  itemCount: indicatorCount,
                  itemExtent: 32.w,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => Padding(
                    padding: EdgeInsets.all(4.0.h),
                    child: Container(
                      height: 3.h,
                      width: 24.w,
                      color:
                          AppColors.green.withOpacity(index == i ? 1.0 : 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardItem {
  final String? name;
  final String? subTitle;
  final String? icon;
  final Function()? onPressed;
  final Color? color;

  const CardItem(
      {this.name, this.subTitle, this.icon, this.onPressed, this.color});
}
