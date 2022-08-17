import 'dart:developer';

import 'package:dreams/utils/draw_actions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMHelper {
  static final GlobalKey<NavigatorState> navState = GlobalKey();
  static String? token = '';
  static config({
    Function(String)? onTokenObtained,
    Function(RemoteMessage, BuildContext)? onForegroundMsg,
    Function(RemoteMessage, BuildContext)? onTerminatedMsg,
    Function(RemoteMessage, BuildContext)? onBackgroundMsg,
  }) async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    if (token != null) onTokenObtained?.call(token!);
    log("FCM Token: $token");
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((event) {
      onForegroundMsg?.call(event, navState.currentContext!);
      log("FCM: ${event.notification!.toMap()}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      onBackgroundMsg?.call(event, navState.currentContext!);
      log("FCM: ${event.notification!.toMap()}");
    });
    final initMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (initMsg != null) {
      if (navState.currentContext == null) await Future.delayed(2.s);
      onForegroundMsg?.call(initMsg, navState.currentContext!);
      log("FCM: ${initMsg.toMap()}");
    }
  }
}
