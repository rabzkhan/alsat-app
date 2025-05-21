import 'dart:developer';
import 'package:alsat/app/components/custom_snackbar.dart';
import 'package:alsat/app/modules/conversation/model/conversations_res.dart';
import 'package:alsat/app/modules/conversation/view/message_view.dart';
import 'package:alsat/app/services/base_client.dart';
import 'package:alsat/app/services/firebase_messaging_services.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/l10n/app_localizations.dart';
import 'package:alsat/utils/constants.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../modules/conversation/controller/conversation_controller.dart';

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
            soundSource: Platform.isIOS
                ? "notification.aiff"
                : 'resource://raw/notification',
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
    Map<String, dynamic> data = receivedAction.payload!;
    if (data["type"] == "chat/inbox") {
      ConversationModel? conversationModel =
          await getConversationInfoByUserId(data["id"]);
      if (conversationModel != null) {
        if (Get.currentRoute != "/MessagesScreen") {
          Get.back();
        }
        Get.to(() => MessagesScreen(conversation: conversationModel));
      }
    }
  }

  Future<void> showFlutterNotification(RemoteMessage m) async {
    log("Message data ${m.data}");
    Get.find<ConversationController>().sortList(m.data["chat_id"]);
    int uniqueId = Math.Random().nextInt(20);
    String? bigPicture = m.notification!.toMap()['android']['imageUrl'];
    String? smallIcon = m.notification!.toMap()['android']['smallIcon'];
    log("RemoteMessage: ${m.data}$bigPicture-- $smallIcon");
    if (bigPicture == null) {
      if (smallIcon == null) {
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: uniqueId,
              channelKey: 'basic_channel',
              summary: "Message from ${m.notification!.title}",
              title: m.notification!.title ??
                  m.data['title'] ??
                  'Notification Title',
              body:
                  m.notification!.body ?? m.data['body'] ?? 'Notification Body',
              actionType: ActionType.Default,
              payload: {
                "type": m.data['type'],
                "id": m.data['sender_id'],
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
                summary: "Message from ${m.notification!.title}",
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
          summary: "Message from ${m.notification!.title}",
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

Future<ConversationModel?> getConversationInfoByUserId(String userId) async {
  ConversationModel? conversationInfo;
  await BaseClient().safeApiCall(
    "${Constants.baseUrl}/chats?user=$userId",
    DioRequestType.get,
    onSuccess: (response) {
      Map<String, dynamic> data = response.data;
      ConversationListRes conversationListRes =
          ConversationListRes.fromJson(data);
      conversationInfo = conversationListRes.data?.firstOrNull;
    },
  );
  return conversationInfo;
}
