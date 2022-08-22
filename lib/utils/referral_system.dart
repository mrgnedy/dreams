// import 'package:dreams/utils/fcm_helper.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';

// class ReferralSystem {
//   static handleTerminatedStateLinks() async {
//     final PendingDynamicLinkData? initialLink =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     if (initialLink != null) {
//       final Uri deepLink = initialLink.link;
//       // Example of using the dynamic link to push the user to a different screen
//       Navigator.pushNamed(FCMHelper.navState.currentContext!, deepLink.path);
//     }
//   }

//   static handleBackgroundLinks() {
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       Navigator.pushNamed(
//           FCMHelper.navState.currentContext!, dynamicLinkData.link.path);
//     }).onError((error) {
//       // Handle errors
//     });
//     // DynamicLinkParameters(
//     //   link: Uri.parse("https://dreams.gulfterminal.com/app"),
//     //   uriPrefix: uriPrefix,
//     //   lo
//     //   iosParameters: IOSParameters(bundleId: 'com.gulfterminal.dreams'),
//     //   androidParameters: AndroidParameters(packageName: 'com.gulfterminal.com'),
//     // );
//   }
// }
