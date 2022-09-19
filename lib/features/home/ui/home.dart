// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreams/features/notfications/data/notification_model.dart';
import 'package:dreams/features/notfications/state/notification_cubit.dart';
import 'package:dreams/features/notfications/ui/notification_screen.dart';
import 'package:dreams/helperWidgets/scalable_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/auth/data/models/auth_state.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/azkar/ui/azkar_list.dart';
import 'package:dreams/features/home/references/ui/references.dart';
import 'package:dreams/features/home/ro2ya/state/mo3beren_cubit.dart';
import 'package:dreams/features/home/ro2ya/ui/mo3aberen_list.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/draw_actions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final carouselIndex = ValueNotifier(0);
  late final BannerAd myBanner;
  @override
  void initState() {
    super.initState();
    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => setState(() {
        showAd = true;
      }),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression. ${ad.responseInfo}'),
    );
    final key = Key('bannerAd');
    myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-2511762886745327/8193469885"
          : "ca-app-pub-2511762886745327/3597293916",
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    )..load();
  }

  bool showAd = false;
  @override
  Widget build(BuildContext context) {
    final itemsList = [
      CardItem(
          name: LocaleKeys.azkarRo2ya,
          subTitle: LocaleKeys.azkarSubtitle,
          color: Color(0xFF008FCD),
          onPressed: () => AzkarScreen(),
          icon: R.ASSETS_IMAGES_AZKAR_PNG),
      if (!isProvider())
        CardItem(
            name: LocaleKeys.ta2weel,
            subTitle: LocaleKeys.ta2weelSubtitle,
            color: Color(0xFF03C491),
            onPressed: () {
              final moaberenCubit = MoaberenCubit()..getMoaberenList();
              return BlocProvider.value(
                  value: moaberenCubit,
                  child: MoaberenListScreen(
                    moaberenCubit: moaberenCubit,
                  ));
            },
            icon: R.ASSETS_IMAGES_ROYA_PNG),
      // CardItem(
      //     name: LocaleKeys.chats,
      //     subTitle: LocaleKeys.chatsSubtitle,
      //     color: Color(0xFFE7C90B),
      //     onPressed: () {},
      //     icon: R.ASSETS_IMAGES_CHAT_PNG),
      CardItem(
          name: LocaleKeys.tafseerRefs,
          subTitle: LocaleKeys.tafseerRefsSub,
          color: Color(0xFFE93D4F),
          onPressed: () => ReferencesScreen(),
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                      // InkWell(
                      //   onTap: () async {
                      //     // final p = await SharedPreferences.getInstance();
                      //     // await p.clear();
                      //     // await di.reset();
                      //     // di.registerLazySingleton(() => AuthCubit());
                      //     // MyApp.restart(context);

                      //     NotificationScreen().push(context);
                      //   },
                      //   child: SizedBox(
                      //     height: 45.r,
                      //     width: 45.r,
                      //     child: Stack(
                      //       fit: StackFit.loose,
                      //       children: [
                      //         Image.asset(
                      //           R.ASSETS_IMAGES_NOTIFICATION_PNG,
                      //           height: 45.r,
                      //           width: 45.r,
                      //           fit: BoxFit.cover,
                      //         ),
                      //         // if (state.data.isNotEmpty)
                      //         NotificationBadge()
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 150.h,
              width: 1.sw,
              child: CarouselSlider(
                items: [
                  Image.asset(R.ASSETS_IMAGES_CARPUSEL_ITEM_PNG),
                  Container(
                    key: UniqueKey(),
                    child: showAd ? AdWidget(ad: myBanner) : FlutterLogo(),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  Image.asset(R.ASSETS_IMAGES_CARPUSEL_ITEM_PNG),
                ],
                options: CarouselOptions(
                    enableInfiniteScroll: false,
                    viewportFraction: 0.9,
                    height: 150.h,
                    onPageChanged: (i, reason) {
                      carouselIndex.value = i.toInt();
                    },
                    enlargeCenterPage: true,
                    autoPlay: true),
              ),
            ),
            // Container(
            //   key: UniqueKey(),
            //   color: AppColors.yellow,
            //   width: 0.5.sw,
            //   height: 0.2.sh,
            //   child: showAd ? AdWidget(ad: myBanner) : FlutterLogo(),
            // ),
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
                                    ScalableImage(
                                      item.icon!,
                                      height: 70.h,
                                    ),
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
                                child: Transform.rotate(
                                  angle: pi * Directionality.of(context).index,
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: item.color,
                                  ),
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

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationModel>(
      builder: (context, state) {
        if (state.data.isEmpty) return SizedBox.shrink();
        return Align(
          alignment: Alignment(1.3, -1.3),
          child: Container(
            height: 20.r,
            width: 20.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: Text(
                  "${state.data.length}",
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                ),
              ),
            ),
          ),
        );
      },
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
    return Center(
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                height: 12.h,
                // width: indicatorCount * 32.w + 100.w,
                child: ValueListenableBuilder<int>(
                  valueListenable: indexNotifier,
                  builder: (countext, index, child) => Container(
                    // color: Colors.red,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // itemCount: indicatorCount,
                      // itemExtent: 40.w,
                      // scrollDirection: Axis.horizontal,
                      children: List.generate(
                          indicatorCount,
                          (i) => Padding(
                                padding: EdgeInsets.all(4.0.h),
                                child: Center(
                                  child: AnimatedContainer(
                                    duration: 300.ms,
                                    height: 3.h,
                                    width: 16.w * (index == i ? 1.5 : 1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.h),
                                      color: AppColors.green.withOpacity(
                                        index == i ? 1.0 : 0.4,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem {
  final dynamic id;
  final String? name;
  final String? subTitle;
  final String? icon;
  final type;
  final Function? onPressed;
  final Color? color;
  final List? args;

  const CardItem(
      {this.name,
      this.id,
      this.subTitle,
      this.icon,
      this.onPressed,
      this.color,
      this.type,
      this.args = const []});

  CardItem copyWith({
    String? name,
    String? subTitle,
    String? icon,
    Function? onPressed,
    Color? color,
    List? args,
    dynamic type,
    dynamic id,
  }) {
    return CardItem(
      name: name ?? this.name,
      id: id ?? this.id,
      subTitle: subTitle ?? this.subTitle,
      icon: icon ?? this.icon,
      onPressed: onPressed ?? this.onPressed,
      color: color ?? this.color,
      args: args ?? this.args,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(covariant CardItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.subTitle == subTitle &&
        other.icon == icon &&
        other.onPressed == onPressed &&
        other.color == color &&
        other.type == type &&
        other.args == args;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        subTitle.hashCode ^
        icon.hashCode ^
        onPressed.hashCode ^
        color.hashCode ^
        type.hashCode ^
        args.hashCode;
  }
}
