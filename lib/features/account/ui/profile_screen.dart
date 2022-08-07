import 'package:dreams/const/colors.dart';
import 'package:dreams/features/account/ui/subscriptions.dart';
import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/auth/ui/change_password.dart';
import 'package:dreams/features/auth/ui/edit_profile.dart';
import 'package:dreams/features/home/ui/home.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/const/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = di<AuthCubit>().state;
    return MainScaffold(
      isAppBarFixed: true,
      gradientAreaHeight: 400.h,
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: CircleAvatar(
                    foregroundColor: Colors.transparent,
                    radius: 70.r,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      R.ASSETS_IMAGES_TEST_PROFILE_PNG,
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
                Container(
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
                          child: Image.asset(R.ASSETS_IMAGES_GOLD_PKG_PNG)),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'باقة إشتراكك الحالية',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12.sp,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'باقة ذهبية',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Text(
                                  '/  متبقي 3 رؤى متوفرة',
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
                ),
              ],
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
            name: "تعديل المعلومات الشخصية",
            icon: R.ASSETS_IMAGES_EDIT_PROFILE_PNG,
            onPressed: () => const EditProfile());
      case AccountSelector.changePassword:
        return CardItem(
            name: "تعديل كلمة المرور",
            icon: R.ASSETS_IMAGES_RESET_PASSWORD_PNG,
            onPressed: () => ChangePasswordScreen());
      case AccountSelector.subscirptions:
        return CardItem(
            name: "الباقات والاشتراكات",
            icon: R.ASSETS_IMAGES_SUBSCRIPTIONS_PNG,
            onPressed: () => SubscriptionsScreen());
      case AccountSelector.about:
        return CardItem(
            name: "عن التطبيق",
            icon: R.ASSETS_IMAGES_ABOUT_PNG,
            onPressed: () {});
      case AccountSelector.contactUs:
        return CardItem(
            name: "تواصل معنا",
            icon: R.ASSETS_IMAGES_CONTACT_PNG,
            onPressed: () {});
      case AccountSelector.logout:
        return CardItem(
            name: "تسجيل الخروج",
            icon: R.ASSETS_IMAGES_LOGOUT_PNG,
            onPressed: () {});
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
            onTap: () => (itemData.onPressed!() as Widget).push(context),
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
