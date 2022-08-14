import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/state/subscriptions_cubit.dart';
import 'package:dreams/features/account/ui/contact_us.dart';
import 'package:dreams/features/account/ui/subscriptions.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/change_password.dart';
import 'package:dreams/features/auth/ui/edit_profile.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/const/resource.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = di<AuthCubit>().state;
    return MainScaffold(
      isAppBarFixed: true,
      gradientAreaHeight: 320,
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CircleAvatar(
                    foregroundColor: Colors.transparent,
                    radius: 60.r,
                    backgroundColor: Colors.transparent,
                    child: Image.network(
                      userData.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  userData.name!,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0.h),
                  child: Text(
                    "عضو منذ ${userData.birthDate}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
                if (di<AuthCubit>().state.subscriptionData != null)
                  const SubscriptionInfo(),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: AccountSelector.values.length,
                itemBuilder: (context, index) {
                  return AccountItem(item: AccountSelector.values[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionInfo extends StatelessWidget {
  const SubscriptionInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subInfo = di<AuthCubit>().state.subscriptionData!.package;
    return Container(
      width: 350.w,
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage(R.ASSETS_IMAGES_SUB_MASK_PNG),
          alignment: AlignmentDirectional.centerStart,
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Image.network(
            subInfo.image,
            height: 80.r,
          )),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.currentSubscription.tr(),
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12.sp,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      subInfo.name,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      '/  ' + LocaleKeys.aboutUs.tr(args: ['11']),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum AccountSelector {
  edit,
  changePassword,
  subscirptions,
  about,
  contactUs,
  logout
}

extension AccountExt on AccountSelector {
  CardItem getData() {
    switch (this) {
      case AccountSelector.edit:
        return CardItem(
            name: LocaleKeys.editProfile.tr(),
            icon: R.ASSETS_IMAGES_EDIT_PROFILE_PNG,
            onPressed: (context) => EditProfile());
      case AccountSelector.changePassword:
        return CardItem(
            name: LocaleKeys.changePassword.tr(),
            icon: R.ASSETS_IMAGES_RESET_PASSWORD_PNG,
            onPressed: (context) => ChangePasswordScreen());
      case AccountSelector.subscirptions:
        return CardItem(
            name: LocaleKeys.packagesSubscriptions.tr(),
            icon: R.ASSETS_IMAGES_SUBSCRIPTIONS_PNG,
            onPressed: (context) => BlocProvider.value(
                value: SubscriptionCubit(), child: SubscriptionsScreen()));
      case AccountSelector.about:
        return CardItem(
            name: LocaleKeys.aboutUs.tr(),
            icon: R.ASSETS_IMAGES_ABOUT_PNG,
            onPressed: (context) => ContactUsScreen());
      case AccountSelector.contactUs:
        return CardItem(
            name: LocaleKeys.contactUs.tr(),
            icon: R.ASSETS_IMAGES_CONTACT_PNG,
            onPressed: (context) => ContactUsScreen());
      case AccountSelector.logout:
        return CardItem(
            name: LocaleKeys.logout.tr(),
            icon: R.ASSETS_IMAGES_LOGOUT_PNG,
            onPressed: (context) {
              di<AuthCubit>().logout(context);
            });
    }
  }
}

class AccountItem extends StatelessWidget {
  final AccountSelector item;
  const AccountItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemData = item.getData();
    final isLogout = item == AccountSelector.logout;
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            highlightColor: AppColors.blue.withOpacity(0.1),
            splashColor: AppColors.blue.withOpacity(0.2),
            onTap: () => (itemData.onPressed!(context) as Widget).push(context),
            child: Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 8.0.w),
                        child: Image.asset(itemData.icon!),
                      ),
                      Text(
                        itemData.name!,
                        style: TextStyle(fontSize: 15.sp),
                      )
                    ],
                  ),
                  if (!isLogout) Image.asset(R.ASSETS_IMAGES_ARROW_OUTLINE_PNG)
                ],
              ),
            ),
          ),
          if (!isLogout)
            Divider(
              indent: 16.w,
              endIndent: 16.w,
            )
          else
            SizedBox(height: 30.h)
        ],
      ),
    );
  }
}
