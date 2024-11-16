import 'dart:convert';
import 'dart:developer';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:alsat/app/modules/conversation/model/conversations_res.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../../../utils/constants.dart';
import '../../../services/base_client.dart';
import '../model/conversation_messages_res.dart';
import '../model/mqtt_message_model.dart';

const String userID = 'bc7eec8f-2a70-4c04-9566-39ead17e5909';

class ConversationController extends GetxController {
  @override
  void onInit() {
    getConversations();
    connectToMqtt();
    super.onInit();
  }

  //-- sent messages --//
  RxBool isSendingMessage = false.obs;
  Future<void> sendMessages(String messages) async {
    Map<String, dynamic> messagesMap = {
      "sender_id": userID,
      "receiver_id": (selectConversation.value?.participants ?? [])
          .firstWhereOrNull((e) => e.id != userID)
          ?.id,
      "content": messages,
      "reply_to": "",
      "attachments": []
    };
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.conversationMessages,
      DioRequestType.post,
      data: messagesMap,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isSendingMessage.value = true;
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        isSendingMessage.value = false;
      },
      onError: (error) {
        isSendingMessage.value = false;
      },
    );
  }

  // get user conversation List
  RxBool isConversationLoading = true.obs;
  RxList<ConversationModel> conversationList = RxList<ConversationModel>();
  Future<void> getConversations() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.userConversationList,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        isConversationLoading.value = true;
        conversationList.value = [];
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        conversationList.value = ConversationListRes.fromJson(data).data ?? [];
        isConversationLoading.value = false;
      },
      onError: (error) {
        isConversationLoading.value = false;
      },
    );
  }

  /// messages
  RxList<MessageModel> selectConversationMessageList = RxList<MessageModel>();
  RxBool isConversationMessageLoading = true.obs;
  Rxn<ConversationModel> selectConversation = Rxn<ConversationModel>();
  Rxn<ConversationMessagesRes> conversationMessagesRes =
      Rxn<ConversationMessagesRes>();
  //cover message model
  RxList<types.Message> coverMessage = RxList<types.Message>([]);
  Future<void> getConversationsMessages() async {
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.conversationMessages,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      queryParameters: {
        'chat_id': selectConversation.value?.id,
      },
      onLoading: () {
        isConversationMessageLoading.value = true;
        selectConversationMessageList.value = [];
        coverMessage.value = [];
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        conversationMessagesRes.value = ConversationMessagesRes.fromJson(data);
        selectConversationMessageList.value =
            conversationMessagesRes.value?.data?.messages ?? [];
        for (var element in selectConversationMessageList) {
          Participant? auth = (selectConversation.value?.participants ?? [])
              .firstWhere((e) => e.id == element.senderId);
          log('auth: ${auth.toJson()}');
          log('seleconversation: ${selectConversation.toJson()}');
          log('message: ${element.toJson()}');

          var message = types.Message.fromJson({
            "author": {
              "firstName": auth.userName,
              "id": auth.id,
              "imageUrl": auth.picture,
              "lastName": ''
            },
            "createdAt":
                (element.createdAt?.microsecondsSinceEpoch ?? 1) ~/ 1000,
            "id": element.id,
            "status": element.status,
            "text": element.content,
            "type": "text"
          });
          coverMessage.add(message);
        }
        isConversationMessageLoading.value = false;
      },
      onError: (error) {
        isConversationMessageLoading.value = false;
      },
    );
  }

  ///
  /// confire with MQTT server
  Future<void> connectToMqtt() async {
    const String host = 'alsat-api.flutterrwave.pro';
    const int port = 1883;

    String clientID = 'user|${DateTime.now().millisecondsSinceEpoch}|$userID';
    const String username = 'user|$userID';
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
      const String topic = 'chat/users/$userID/inbox';
      client.subscribe(topic, MqttQos.exactlyOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        //-- After Subscribe ---//
        final MqttPublishMessage recMessage =
            messages[0].payload as MqttPublishMessage;
        final String messageJson = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        log("Received message JSON: $messageJson");
        try {
          final messageData = jsonDecode(messageJson);
          MqttMessageModel messageModel =
              MqttMessageModel.fromJson(messageData);
          checkMessagesToPush(messageModel);
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

  //-- Check Auther Message --//
  checkMessagesToPush(MqttMessageModel mqttMessageModel) {
    ConversationModel? conversation = conversationList.firstWhereOrNull(
        (element) =>
            element.participants?.lastOrNull?.id ==
            mqttMessageModel.sender?.id);
    //-- Check if conversation exist --//
    if (conversation == null) {
      getConversations();
    }
    //-- Check if conversation is selected --//
    if (selectConversation.value?.participants?.lastOrNull?.id ==
        mqttMessageModel.sender?.id) {
      log('message is from selected conversation');
      var message = types.Message.fromJson({
        "author": {
          "firstName": mqttMessageModel.sender?.userName,
          "id": mqttMessageModel.sender?.id,
          "imageUrl": mqttMessageModel.sender?.picture,
          "lastName": ''
        },
        "createdAt":
            (mqttMessageModel.createdAt?.microsecondsSinceEpoch ?? 1) ~/ 1000,
        "id": mqttMessageModel.id,
        "status": mqttMessageModel.status,
        "text": mqttMessageModel.content,
        "type": "text"
      });
      log('$message');

      coverMessage.insert(0, message);
      coverMessage.refresh();
    }
    if (conversation != null) {
      MessageModel? message = MessageModel(
        id: mqttMessageModel.id,
        senderId: mqttMessageModel.sender?.id,
        content: mqttMessageModel.content,
        createdAt: mqttMessageModel.createdAt,
        status: mqttMessageModel.status,
        attachments: mqttMessageModel.attachments,
        chatId: conversation.id,
        receiverId: conversation.participants?.lastOrNull?.id,
        updatedAt: mqttMessageModel.updatedAt,
        accessedAt: mqttMessageModel.accessedAt,
      );
      conversation.lastMessage = message;
      conversationList.refresh();
    }
  }
}
