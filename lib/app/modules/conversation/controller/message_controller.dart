import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../../../utils/constants.dart';
import '../../authentication/controller/auth_controller.dart';

class MessageController extends GetxController {
  Future<void> checkUserActiveLive({required String userID}) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    const String host = 'alsat-api.flutterrwave.pro';
    const int port = 1883;
    String clientID = 'user|$fcmToken|$userID';
    String username = 'user|$userID';
    const String password = Constants.token1;
    final MqttServerClient client = MqttServerClient(host, clientID);
    client.port = port;
    client.logging(on: true);
    client.setProtocolV311();

    final MqttConnectMessage connMessage = MqttConnectMessage()
        .withClientIdentifier(clientID)
        .authenticateAs(username, password)
        .startClean();

    client.connectionMessage = connMessage;

    try {
      await client.connect().then((onValue) {
        log('Connected to MQTT server $onValue');
      }).catchError((error) {
        log('Connection failed: $error');
      });
      String topic = 'chat/users/$userID/online';
      client.subscribe(topic, MqttQos.exactlyOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        //-- After Subscribe ---//
        final MqttPublishMessage recMessage =
            messages[0].payload as MqttPublishMessage;
        final String messageJson = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        log("UserOnline Status: $messageJson");
        try {
          final messageData = jsonDecode(messageJson);
        } catch (e) {
          log("Error parsing message JSON: $e");
        }
      });
    } catch (e) {
      log('Connection failed: $e');
      client.disconnect();
    }
  }

  void onDisconnected() {
    log('Disconnected from the MQTT broker');
  }
}
