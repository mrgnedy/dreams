// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:dreams/features/home/ui/navigation_screen.dart';
import 'package:dreams/features/notfications/ui/notification_screen.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/utils/fcm_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  static createLocalNotification(RemoteMessage remoteMessage) {
    fl.show(
      0,
      remoteMessage.notification!.title!+"12",
      remoteMessage.notification!.body,
      const NotificationDetails(
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  static requestLocalNotificationPermissions() async {
    try {
      fl
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      log("IOS: $e");
    }
    try {
      fl
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    } catch (e) {
      log("ANDROID: $e");
    }
  }

  static localNotificationListener() {}

  static final fl = FlutterLocalNotificationsPlugin();
  static initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_foreground');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await fl.initialize(initializationSettings);
  }

  static init() async {
    await requestLocalNotificationPermissions();
    await initLocalNotification();
  }
}
