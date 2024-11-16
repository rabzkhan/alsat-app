import 'dart:developer';
import 'package:alsat/app/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../main.dart';

class FirebaseMessagingService {
  FirebaseMessagingService() {
    initFirebase();
    _catchNotificationFromServer();
    _topicSubscription();
    _notificationPermission();
    NotificationService();
  }

  initFirebase() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("FCMToken : $fcmToken");
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
  }

  ///
  _catchNotificationFromServer() {
    //Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().showFlutterNotification(message);
    });
    //onBackgroundMessage messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        //redirect user in specific page
        redirectUserBasePayload(message.data);
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) {});
  }

  _topicSubscription() async {
    await FirebaseMessaging.instance.subscribeToTopic('test-app');
  }

  Future<void> _notificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  static redirectUserBasePayload(Map<String, dynamic> data) async {}
}
