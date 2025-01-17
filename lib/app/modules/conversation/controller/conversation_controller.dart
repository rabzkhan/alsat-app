import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/utils/helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:alsat/app/modules/conversation/model/conversations_res.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../utils/constants.dart';
import '../../../components/custom_snackbar.dart';
import '../../../services/base_client.dart';
import '../model/conversation_messages_res.dart';
import '../model/message_model.dart';
import '../model/mqtt_message_model.dart';
import 'message_controller.dart';

class ConversationController extends GetxController {
  Rxn<Duration> recordTime = Rxn<Duration>();
  final reportFromKey = GlobalKey<FormBuilderState>();

  @override
  void onInit() {
    getConversations();
    connectToMqtt();

    super.onInit();
  }

  //-- sent messages --//
  RxBool isSendingMessage = false.obs;
  Future<void> sendMessageToServer(String messages,
      {Map<String, dynamic>? map}) async {
    MessageController messageController =
        Get.put(MessageController(), tag: '${selectConversation.value?.id}');
    AuthController authController = Get.find();
    String uId = authController.userDataModel.value.id ?? "";
    Map<String, dynamic> messagesMap = {
      "sender_id": uId,
      "receiver_id": (selectConversation.value?.participants ?? [])
          .firstWhereOrNull((e) => e.id != uId)
          ?.id,
      "content": messages,
      "reply_to": messageController.selectReplyMessage.value?.id ?? '',
      "attachments": [map]
    };
    messageController.selectReplyMessage.value = null;
    // log('messagesMap: $messagesMap');

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
        log('Error: $error');
      },
    );
  }

  // get user conversation List
  RxBool isConversationLoading = true.obs;
  RxList<ConversationModel> conversationList = RxList<ConversationModel>();
  Future<void> getConversations({String? paginate}) async {
    String url = Constants.baseUrl + Constants.userConversationList;
    if (paginate != null) {
      url = "$url?next=$paginate";
    }
    await BaseClient.safeApiCall(
      url,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {
        if (paginate == null) {
          isConversationLoading.value = true;
          conversationList.value = [];
        }
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        if (paginate == null) {
          conversationList.value =
              ConversationListRes.fromJson(data).data ?? [];
        } else {
          conversationList
              .addAll(ConversationListRes.fromJson(data).data ?? []);
        }
        conversationList.refresh();
        isConversationLoading.value = false;
      },
      onError: (error) {
        isConversationLoading.value = false;
      },
    );
  }

  //--- Coversation List Pagenation ---//
  RefreshController conversationRefreshController =
      RefreshController(initialRefresh: false);
  void conversationRefresh() async {
    await getConversations();
    conversationRefreshController.refreshCompleted();
  }

  void conversationLoading() async {
    await getConversations(paginate: conversationList.last.createdAt);
    conversationRefreshController.loadComplete();
  }

  /// messages
  RxList<MessageModel> selectConversationMessageList = RxList<MessageModel>();
  RxBool isConversationMessageLoading = true.obs;
  Rxn<ConversationModel> selectConversation = Rxn<ConversationModel>();
  Rxn<ConversationMessagesRes> conversationMessagesRes =
      Rxn<ConversationMessagesRes>();
  RxList<ChatMessage> coverMessage = RxList<ChatMessage>([]);
  AuthController authController = Get.find<AuthController>();
  Rxn<Participant> selectUserInfo = Rxn();
  //cover message model
  Future<void> getConversationsMessages({String? next}) async {
    log("selectConversation.value?.id ${selectConversation.value?.id}");
    await BaseClient.safeApiCall(
      Constants.baseUrl + Constants.conversationMessages,
      DioRequestType.get,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      queryParameters: next == null
          ? {
              'chat_id': selectConversation.value?.id,
            }
          : {
              'chat_id': selectConversation.value?.id,
              'next': next,
            },
      onLoading: () {
        if (next == null) {
          isConversationMessageLoading.value = true;
          selectConversationMessageList.value = [];
          coverMessage.value = [];
        }
      },
      onSuccess: (response) async {
        Map<String, dynamic> data = response.data;
        conversationMessagesRes.value = ConversationMessagesRes.fromJson(data);
        selectConversationMessageList.value =
            conversationMessagesRes.value?.data?.messages ?? [];
        Map<String, Participant>? map =
            conversationMessagesRes.value?.data?.participants;
        map?.remove(authController.userDataModel.value.id.toString());
        selectUserInfo.value = map?.values.toList().first;

        for (var element in selectConversationMessageList) {
          if (element.attachments != null &&
              (element.attachments ?? []).isNotEmpty) {
            for (Attachment e in element.attachments ?? []) {
              if (e.type == 'image') {
                coverMessage.add(
                  ChatMessage(
                    id: element.id ?? '0',
                    text: element.content ?? '',
                    messageType: ChatMessageType.image,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id ==
                        element.senderId,
                    time: element.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo.value?.id ?? "",
                      name: selectUserInfo.value?.userName ?? '',
                      imageUrl: selectUserInfo.value?.picture ?? '',
                    ),
                    data: e.data,
                    replyMessage: element.replyTo == null
                        ? null
                        : ChatMessage(
                            id: element.replyTo?.id ?? '0',
                            text: element.replyTo?.content ?? '',
                            messageType: ChatMessageType.text,
                            messageStatus: MessageStatus.viewed,
                            isSender: authController.userDataModel.value.id ==
                                element.replyTo?.sender?.id,
                            time: element.replyTo?.createdAt ?? DateTime.now(),
                            otherUser: ChatUser(
                              id: selectUserInfo.value?.id ?? "",
                              name: selectUserInfo.value?.userName ?? '',
                              imageUrl: selectUserInfo.value?.picture ?? '',
                            ),
                            data: e.data,
                          ),
                  ),
                );
              }
              if (e.type == 'video') {
                coverMessage.add(
                  ChatMessage(
                    id: element.id ?? '0',
                    text: element.content ?? '',
                    messageType: ChatMessageType.video,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id ==
                        element.senderId,
                    time: element.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo.value?.id ?? "",
                      name: selectUserInfo.value?.userName ?? '',
                      imageUrl: selectUserInfo.value?.picture ?? '',
                    ),
                    data: e.data,
                    replyMessage: element.replyTo == null
                        ? null
                        : ChatMessage(
                            id: element.replyTo?.id ?? '0',
                            text: element.replyTo?.content ?? '',
                            messageType: ChatMessageType.text,
                            messageStatus: MessageStatus.viewed,
                            isSender: authController.userDataModel.value.id ==
                                element.replyTo?.sender?.id,
                            time: element.replyTo?.createdAt ?? DateTime.now(),
                            otherUser: ChatUser(
                              id: selectUserInfo.value?.id ?? "",
                              name: selectUserInfo.value?.userName ?? '',
                              imageUrl: selectUserInfo.value?.picture ?? '',
                            ),
                            data: e.data,
                          ),
                  ),
                );
              }
              if (e.type == 'location') {
                coverMessage.add(
                  ChatMessage(
                    id: element.id ?? '0',
                    text: element.content ?? '',
                    messageType: ChatMessageType.map,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id ==
                        element.senderId,
                    time: element.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo.value?.id ?? "",
                      name: selectUserInfo.value?.userName ?? '',
                      imageUrl: selectUserInfo.value?.picture ?? '',
                    ),
                    data: e.data,
                    replyMessage: element.replyTo == null
                        ? null
                        : ChatMessage(
                            id: element.replyTo?.id ?? '0',
                            text: element.replyTo?.content ?? '',
                            messageType: ChatMessageType.text,
                            messageStatus: MessageStatus.viewed,
                            isSender: authController.userDataModel.value.id ==
                                element.replyTo?.sender?.id,
                            time: element.replyTo?.createdAt ?? DateTime.now(),
                            otherUser: ChatUser(
                              id: selectUserInfo.value?.id ?? "",
                              name: selectUserInfo.value?.userName ?? '',
                              imageUrl: selectUserInfo.value?.picture ?? '',
                            ),
                            data: e.data,
                          ),
                  ),
                );
              }
              if (e.type == 'audio') {
                coverMessage.add(
                  ChatMessage(
                    id: element.id ?? '0',
                    text: element.content ?? '',
                    messageType: ChatMessageType.audio,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id ==
                        element.senderId,
                    time: element.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo.value?.id ?? "",
                      name: selectUserInfo.value?.userName ?? '',
                      imageUrl: selectUserInfo.value?.picture ?? '',
                    ),
                    data: e.data,
                    replyMessage: element.replyTo == null
                        ? null
                        : ChatMessage(
                            id: element.replyTo?.id ?? '0',
                            text: element.replyTo?.content ?? '',
                            messageType: ChatMessageType.text,
                            messageStatus: MessageStatus.viewed,
                            isSender: authController.userDataModel.value.id ==
                                element.replyTo?.sender?.id,
                            time: element.replyTo?.createdAt ?? DateTime.now(),
                            otherUser: ChatUser(
                              id: selectUserInfo.value?.id ?? "",
                              name: selectUserInfo.value?.userName ?? '',
                              imageUrl: selectUserInfo.value?.picture ?? '',
                            ),
                            data: e.data,
                          ),
                  ),
                );
              }
              if (e.type == 'post') {
                coverMessage.add(
                  ChatMessage(
                    id: element.id ?? '0',
                    text: element.content ?? '',
                    messageType: ChatMessageType.post,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id ==
                        element.senderId,
                    time: element.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo.value?.id ?? "",
                      name: selectUserInfo.value?.userName ?? '',
                      imageUrl: selectUserInfo.value?.picture ?? '',
                    ),
                    data: e.data,
                    replyMessage: element.replyTo == null
                        ? null
                        : ChatMessage(
                            id: element.replyTo?.id ?? '0',
                            text: element.replyTo?.content ?? '',
                            messageType: ChatMessageType.text,
                            messageStatus: MessageStatus.viewed,
                            isSender: authController.userDataModel.value.id ==
                                element.replyTo?.sender?.id,
                            time: element.replyTo?.createdAt ?? DateTime.now(),
                            otherUser: ChatUser(
                              id: selectUserInfo.value?.id ?? "",
                              name: selectUserInfo.value?.userName ?? '',
                              imageUrl: selectUserInfo.value?.picture ?? '',
                            ),
                            data: e.data,
                          ),
                  ),
                );
              }
              if ((e.type ?? '').trim().isEmpty) {
                coverMessage.add(
                  ChatMessage(
                    id: element.id ?? '0',
                    text: element.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id ==
                        element.senderId,
                    time: element.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo.value?.id ?? "",
                      name: selectUserInfo.value?.userName ?? '',
                      imageUrl: selectUserInfo.value?.picture ?? '',
                    ),
                    data: null,
                    replyMessage: element.replyTo == null
                        ? null
                        : ChatMessage(
                            id: element.replyTo?.id ?? '0',
                            text: element.replyTo?.content ?? '',
                            messageType: ChatMessageType.text,
                            messageStatus: MessageStatus.viewed,
                            isSender: authController.userDataModel.value.id ==
                                element.replyTo?.sender?.id,
                            time: element.replyTo?.createdAt ?? DateTime.now(),
                            otherUser: ChatUser(
                              id: selectUserInfo.value?.id ?? "",
                              name: selectUserInfo.value?.userName ?? '',
                              imageUrl: selectUserInfo.value?.picture ?? '',
                            ),
                            data: e.data,
                          ),
                  ),
                );
              }
            }
          } else {
            coverMessage.add(
              ChatMessage(
                id: element.id ?? '0',
                text: element.content ?? '',
                messageType: ChatMessageType.text,
                messageStatus: MessageStatus.viewed,
                isSender:
                    authController.userDataModel.value.id == element.senderId,
                time: element.createdAt ?? DateTime.now(),
                otherUser: ChatUser(
                  id: selectUserInfo.value?.id ?? "",
                  name: selectUserInfo.value?.userName ?? '',
                  imageUrl: selectUserInfo.value?.picture ?? '',
                ),
                data: null,
              ),
            );
          }
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
    AuthController authController = Get.find();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    String userID = authController.userDataModel.value.id ?? "";
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
      String topic = 'chat/users/$userID/inbox';
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
          log("MqttMessageModel  ${messageModel.toJson()}");
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
      var newMessage = ChatMessage(
        id: mqttMessageModel.sender?.id ?? '0',
        text: mqttMessageModel.content ?? '',
        messageType: ChatMessageType.text,
        messageStatus: MessageStatus.notView,
        isSender: authController.userDataModel.value.id ==
            mqttMessageModel.sender?.id,
        time: mqttMessageModel.createdAt ?? DateTime.now(),
        otherUser: ChatUser(
          id: selectUserInfo.value?.id ?? "",
          name: selectUserInfo.value?.userName ?? '',
          imageUrl: selectUserInfo.value?.picture ?? '',
        ),
        data: null,
      );

      coverMessage.insert(0, newMessage);
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
  //

  RxString typeMessageText = RxString('');
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  sendMessage(
      {File? image, File? video, LatLng? location, String? audioPath}) async {
    scrollToBottom();
    ChatMessage message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: typeMessageText.value,
      messageType: image != null
          ? ChatMessageType.image
          : location != null
              ? ChatMessageType.map
              : audioPath != null
                  ? ChatMessageType.audio
                  : video != null
                      ? ChatMessageType.video
                      : ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
      isSender: true,
      time: DateTime.now(),
      otherUser: ChatUser(
        id: selectUserInfo.value?.id ?? "",
        name: selectUserInfo.value?.userName ?? '',
        imageUrl: selectUserInfo.value?.picture ?? '',
      ),
      data: image?.path ??
          video?.path ??
          (location != null
              ? [location.latitude, location.longitude]
              : audioPath),
    );
    coverMessage.insert(0, message);
    coverMessage.refresh();
    if (image != null) {
      Map<String, dynamic> data = {
        "type": "image",
        "file": await imageToBase64(image.path),
      };
      sendMessageToServer(messageController.text, map: data);
    } else if (video != null) {
      Map<String, dynamic> data = {
        "type": "video",
        "file": await videoToBase64(video.path),
      };
      sendMessageToServer(messageController.text, map: data);
    } else if (location != null) {
      Map<String, dynamic> data = {
        "type": "location",
        "location": {
          "type": "point",
          "coordinates": [location.latitude, location.longitude]
        }
      };
      sendMessageToServer(messageController.text, map: data);
    } else if (audioPath != null) {
      Map<String, dynamic> map = {
        "type": "audio",
        "file": await audioToBase64(audioPath),
      };
      sendMessageToServer(messageController.text, map: map);
    } else {
      sendMessageToServer(messageController.text);
    }

    typeMessageText.value = '';
    messageController.clear();
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollToBottom();
    });
  }

  scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut, // Better curve for smooth scrolling
      );
    }
  }

  //-- refresh controller for conversation --//
  RefreshController refreshMessageController =
      RefreshController(initialRefresh: false);

  void onRefreshMessage() async {
    refreshMessageController.refreshCompleted();
  }

  void onLoadingMessage() async {
    if (conversationMessagesRes.value?.hasMore ?? false) {
      await getConversationsMessages(
          next:
              selectConversationMessageList.last.createdAt?.toIso8601String());
    }
    refreshMessageController.loadComplete();
  }

  //-- delete message --//
  deleteMessage(String messageId) async {
    coverMessage.removeWhere((element) => element.id == messageId);
    coverMessage.refresh();
    deleteMessageFromServer(messageId);
  }

  //-- delete message From server --//
  deleteMessageFromServer(String messageId) async {
    ///messages/:messageID
    await BaseClient.safeApiCall(
      "${Constants.baseUrl}${Constants.conversationMessages}/$messageId?userID=${authController.userDataModel.value.id}",
      DioRequestType.delete,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {},
      onSuccess: (response) async {
        log('deleteMessageFromServer: $response');
      },
      onError: (error) {
        log('deleteMessageFromServer: $error');
        log(
          "${Constants.baseUrl}${Constants.conversationMessages}/$messageId?userID:${authController.userDataModel.value.id}",
        );
      },
    );
  }

  //--- Block User --//
  RxBool isBlockUser = false.obs;
  Future<bool> blockUser(String id, String uId, {bool isBlock = true}) async {
    log('blockUser: $id ${'${Constants.baseUrl}${Constants.userConversationList}/$id/block'}');
    isBlockUser.value = true;
    return await BaseClient.safeApiCall(
      '${Constants.baseUrl}${Constants.userConversationList}/$id/block',
      DioRequestType.put,
      data: {"user_id": uId, "block": isBlock},
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      onLoading: () {},
      onSuccess: (response) async {
        isBlockUser.value = false;
        CustomSnackBar.showCustomToast(message: 'User Blocked Successfully');
        getConversations();
        if (isBlock) Get.back();
        Get.back();
        return true;
      },
      onError: (error) {
        CustomSnackBar.showCustomToast(
            message: 'Something went wrong', color: Colors.red);
        isBlockUser.value = false;
        log('blockUser Error: $error');
        return false;
      },
    );
  }

  //-- sendReport --//
  RxBool isReport = false.obs;
  Future<bool> sendReport(Map<String, dynamic> data) async {
    return BaseClient.safeApiCall(
      '${Constants.baseUrl}/reports',
      DioRequestType.post,
      headers: {
        //'Authorization': 'Bearer ${MySharedPref.getAuthToken().toString()}',
        'Authorization': Constants.token,
      },
      data: data,
      onLoading: () {
        isReport.value = true;
      },
      onSuccess: (response) async {
        log('sendReport: $response');
        isReport.value = false;
        Get.back();
        CustomSnackBar.showCustomToast(
            title: 'Reported', message: 'User Reported Successfully');
        return true;
      },
      onError: (error) {
        log('sendReport Error: $error');
        isReport.value = false;
        Get.back();
        CustomSnackBar.showCustomErrorToast(
            title: 'Error', message: 'Something went wrong');
        return false;
      },
    );
  }
}
