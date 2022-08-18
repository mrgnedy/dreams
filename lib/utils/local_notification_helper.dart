import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dreams/features/notfications/ui/notification_screen.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/utils/fcm_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LocalNotificationHelper {
  static createLocalNotification(RemoteMessage remoteMessage) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: '0',
            title: remoteMessage.notification!.title,
            body: remoteMessage.notification!.body,
            // icon: R.ASSETS_IMAGES_LOGOUT_PNG,
            icon: "resource://drawable/launcher_icon",
            wakeUpScreen: true,
            color: Colors.red,
            backgroundColor: Colors.black26,
            notificationLayout: NotificationLayout.Default,
            payload: remoteMessage
                .toMap()
                .map((key, value) => MapEntry(key, '$value'))));
  }

  static requestLocalNotificationPermissions() async {
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      log("isAllowed: $isAllowed");
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static localNotificationListener() {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      log("Local Notification: ${receivedNotification.payload}");
      const NotificationScreen().push(FCMHelper.navState.currentState!.context);
      // Navigator.of(FCMHelper.navState.currentState!.context)
      //     .pushNamed('/NotificationPage', arguments: {
      //   // your page params. I recommend you to pass the
      //   // entire *receivedNotification* object
      //   id: receivedNotification.id
      // });
    });
  }

  static initLocalNotification() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon

        "resource://drawable/launcher_icon",
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: '0',
              channelName: 'Basic notifications',
              importance: NotificationImportance.High,
              icon: "resource://drawable/launcher_icon",
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              channelShowBadge: true,
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);
  }

  static init() async {
    await requestLocalNotificationPermissions();
    // Add this
    await initLocalNotification();
    localNotificationListener();
  }
}
