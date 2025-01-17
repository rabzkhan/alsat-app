import 'dart:convert';
import 'dart:developer';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../../../utils/constants.dart';
import '../model/message_model.dart';

class MessageController extends GetxController {
  Rxn<ChatMessage> selectMessage = Rxn<ChatMessage>();
  Rxn<ChatMessage> selectReplyMessage = Rxn<ChatMessage>();
  RxBool isOnlineUser = RxBool(false);
  Rxn<DateTime> lastSeen = Rxn<DateTime>();
  Future<void> checkUserActiveLive({required String userID}) async {
    final AuthController authController = Get.find<AuthController>();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    const String host = 'alsat-api.flutterrwave.pro';
    const int port = 1883;
    String clientID = 'user|$fcmToken|${authController.userDataModel.value.id}';
    String username = 'user|${authController.userDataModel.value.id}';
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
      await client.connect().then((onValue) {}).catchError((error) {});
      String topic = 'chat/users/$userID/online';
      client.subscribe(topic, MqttQos.exactlyOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        //-- After Subscribe ---//
        final MqttPublishMessage recMessage =
            messages[0].payload as MqttPublishMessage;
        final String messageJson = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);

        try {
          final Map<String, dynamic> decodedJson = jsonDecode(messageJson);
          lastSeen.value = DateTime.parse(decodedJson["last_seen_at"]);
          isOnlineUser.value = decodedJson["online"];
        } catch (e) {
          log("Error parsing message JSON: $e");
        }
      });
    } catch (e) {
      client.disconnect();
    }
  }

  void onDisconnected() {
    log('Disconnected from the MQTT broker');
  }
}
