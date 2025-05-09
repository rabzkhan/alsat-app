import 'dart:convert';
import 'dart:developer';
import 'package:alsat/app/data/local/my_shared_pref.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/services/base_client.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../../../utils/constants.dart';
import '../../product/model/product_post_list_res.dart';
import '../model/message_model.dart';

class MessageController extends GetxController {
  Rxn<ProductModel> selectProductModel = Rxn<ProductModel>();
  Rxn<ChatMessage> selectMessage = Rxn<ChatMessage>();
  Rxn<ChatMessage> selectReplyMessage = Rxn<ChatMessage>();
  RxBool isOnlineUser = RxBool(false);
  Rxn<DateTime> lastSeen = Rxn<DateTime>();
  late MqttServerClient client;
  @override
  void onClose() {
    client.disconnect();
    super.onClose();
  }

  Future<void> checkUserActiveLive({required String userID}) async {
    final AuthController authController = Get.find<AuthController>();
    const String host = 'alsat-api.flutterrwave.pro';
    const int port = 1883;
    String clientID = 'user|${DateTime.now().millisecondsSinceEpoch}|${authController.userDataModel.value.id}';
    String username = 'user|${authController.userDataModel.value.id}';
    String? password = MySharedPref.getAuthToken();
    client = MqttServerClient(host, clientID);
    client.port = port;
    client.logging(on: true);
    client.setProtocolV311();

    final MqttConnectMessage connMessage =
        MqttConnectMessage().withClientIdentifier(clientID).authenticateAs(username, password).startClean();

    client.connectionMessage = connMessage;

    try {
      await client.connect().then((onValue) {}).catchError((error) {});
      String topic = 'chat/users/$userID/online';
      client.subscribe(topic, MqttQos.exactlyOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        //-- After Subscribe ---//
        final MqttPublishMessage recMessage = messages[0].payload as MqttPublishMessage;
        final String messageJson = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

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

  //read all unseen messages--//
  Future<void> readAllUnSeenMessages(String chatId) async {
    return BaseClient().safeApiCall(
      '${Constants.baseUrl}${Constants.userConversationList}/$chatId/status',
      DioRequestType.put,
      data: {"status": "read"},
      onLoading: () {},
      onSuccess: (response) async {
        log('read all unseen messages');
      },
      onError: (error) {
        log('read all unseen messages error: ${error.toString()}');
      },
    );
  }
}
