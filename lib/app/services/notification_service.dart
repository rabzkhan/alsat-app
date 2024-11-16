import 'dart:developer';
import 'package:alsat/app/services/firebase_messaging_services.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math' as Math;
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService() {
    setupFlutterNotifications();
    listenActionStream();
  }

  Future<void> setupFlutterNotifications() async {
    AwesomeNotifications().initialize(
        'resource://drawable/logo',
        [
          NotificationChannel(
            playSound: true,
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: AppColors.primary,
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            enableLights: true,
            enableVibration: true,
          )
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  listenActionStream() {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log("AwesomeNotifications Press:");
    if (receivedAction.actionType == ActionType.SilentAction) {
      if (receivedAction.payload != null) {}
    } else {
      if (receivedAction.payload != null) {
        log("AwesomeNotifications Press: ${receivedAction.payload}");
        FirebaseMessagingService.redirectUserBasePayload({
          "type": receivedAction.payload!['type'],
          "id": receivedAction.payload!['id'] ??
              receivedAction.payload!['fixtureId'],
        });
      }
    }
  }

  Future<void> showFlutterNotification(RemoteMessage m) async {
    log("${m.data}");
    int uniqueId = Math.Random().nextInt(20);
    String? bigPicture = m.notification!.toMap()['android']['imageUrl'];
    String? smallIcon = m.notification!.toMap()['android']['smallIcon'];
    log("$bigPicture-- $smallIcon");
    if (bigPicture == null) {
      if (smallIcon == null) {
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: uniqueId,
              channelKey: 'basic_channel',
              summary: "Sports Notification",
              title: m.notification!.title ??
                  m.data['title'] ??
                  'Notification Title',
              body:
                  m.notification!.body ?? m.data['body'] ?? 'Notification Body',
              actionType: ActionType.Default,
              payload: {
                "type": m.data['type'],
                "id": m.data['id'] ?? m.data['fixtureId'],
              },
            ),
            actionButtons: [
              NotificationActionButton(
                key: 'MARK_DONE',
                label: 'Open',
                color: Colors.red,
              )
            ]);
      } else {
        log("NotificationLayout.BigText");
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: uniqueId,
                largeIcon: smallIcon,
                channelKey: 'basic_channel',
                summary: "Sports Notification",
                title: m.notification!.title ??
                    m.data['title'] ??
                    'Notification Title',
                body: m.notification!.body ??
                    m.data['body'] ??
                    'Notification Body',
                actionType: ActionType.Default,
                payload: {
                  "type": m.data['type'],
                  "id": m.data['id'] ?? m.data['fixtureId'],
                },
                notificationLayout: NotificationLayout.BigText),
            actionButtons: [
              NotificationActionButton(
                key: 'MARK_DONE',
                label: 'Open',
                color: Colors.red,
              )
            ]);
      }
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: uniqueId,
          channelKey: 'basic_channel',
          summary: "Sports Notification",
          largeIcon: smallIcon ?? bigPicture,
          color: Colors.amber,
          backgroundColor: AppColors.primary,
          title:
              m.notification!.title ?? m.data['title'] ?? 'Notification Title',
          body: m.notification!.body ?? m.data['body'] ?? 'Notification Body',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: m.data['type'] == 'news' ? smallIcon : bigPicture,
          roundedLargeIcon: true,
          payload: {
            "type": m.data['type'],
            "id": m.data['id'] ?? m.data['fixtureId'],
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'MARK_DONE',
            label: 'Open',
            color: Colors.red,
          )
        ],
      );
    }
  }

  ///notification
}
