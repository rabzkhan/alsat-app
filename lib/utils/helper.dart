import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

import 'package:crypto/crypto.dart';

import '../app/modules/authentication/controller/auth_controller.dart';
import '../app/modules/conversation/model/conversation_messages_res.dart';
import '../app/modules/conversation/model/message_model.dart';

String timeAgo(DateTime date) {
  final clock = DateTime.now();
  var elapsed = clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
  final num seconds = elapsed / 1000;
  final num minutes = seconds / 60;
  final num hours = minutes / 60;
  final num days = hours / 24;
  final num months = days / 30;
  final num years = days / 365;

  if (seconds < 45) {
    return "${seconds.round()}s ago";
  } else if (seconds < 90) {
    return "Minute ago";
  } else if (minutes < 45) {
    return "${minutes.round()} minutes ago";
  } else if (minutes < 90) {
    return "Hour ago";
  } else if (hours < 24) {
    return "${hours.round()} hours ago";
  } else if (hours < 48) {
    return "Day ago";
  } else if (days < 30) {
    return "${days.round()} days ago";
  } else if (days < 60) {
    return "Month ago";
  } else if (days < 365) {
    return "${months.round()} months ago";
  } else if (years < 1) {
    return "Year ago";
  } else {
    return "${years.round()} years ago";
  }
}

Future<Map<String, dynamic>> imageToBase64(String filePath) async {
  String base64String = await convertImageToBase64(filePath);
  String extension = path.extension(filePath).toLowerCase();
  String contentType;
  switch (extension) {
    case '.jpg':
    case '.jpeg':
      contentType = 'image/jpeg';
      break;
    case '.png':
      contentType = 'image/png';
      break;
    case '.gif':
      contentType = 'image/gif';
      break;
    case '.bmp':
      contentType = 'image/bmp';
      break;
    case '.webp':
      contentType = 'image/webp';
      break;
    default:
      contentType = 'application/octet-stream';
  }
  var jsonObject = {
    "name": base64String,
    "type": "image",
    "size": File(filePath).lengthSync(),
    "hash": calculateHash(base64String),
    "content_type": contentType
  };
  return jsonObject;
}

String calculateHash(String base64String) {
  return base64String.hashCode.toString();
}

Future<String> convertImageToBase64(String filePath) async {
  File imageFile = File(filePath);
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

//
Future<String> convertFileToBase64(String filePath) async {
  final bytes = await File(filePath).readAsBytes();
  return base64Encode(bytes);
}

Future<Map<String, dynamic>> videoToBase64(String filePath) async {
  String base64String = await convertFileToBase64(filePath);
  String extension = path.extension(filePath).toLowerCase();
  String contentType;

  // Determine content type based on file extension
  switch (extension) {
    case '.mp4':
      contentType = 'video/mp4';
      break;
    case '.avi':
      contentType = 'video/x-msvideo';
      break;
    case '.mov':
      contentType = 'video/quicktime';
      break;
    case '.mkv':
      contentType = 'video/x-matroska';
      break;
    case '.webm':
      contentType = 'video/webm';
      break;
    default:
      contentType = 'application/octet-stream';
  }

  // Creating a JSON object for the video
  var jsonObject = {
    "name": base64String,
    "type": "video",
    "size": File(filePath).lengthSync(),
    "hash": calculateHash(base64String),
    "content_type": contentType
  };

  return jsonObject;
}

Future<Map<String, dynamic>> audioToBase64(String filePath) async {
  try {
    Map<String, dynamic> fileData = {};
    File file = File(filePath);

    if (await file.exists()) {
      Uint8List fileBytes = await file.readAsBytes();
      //log('audioFilePath Uint8List $fileBytes');
      String base64String = base64Encode(fileBytes);

      int fileSize = file.lengthSync();
      // log('audioFilePath fileSize $fileSize');
      String hash = calculateHashAudio(fileBytes);
      //log('audioFilePath hash $hash');
      fileData = {
        "name": base64String,
        "type": "audio",
        "size": fileSize,
        "hash": hash,
        "content_type": "audio/m4a",
      };
    }
    return fileData;
  } catch (e) {
    log('audioFilePath error $e');
    return {};
  }
}

String calculateHashAudio(Uint8List fileBytes) {
  var bytes = sha256.convert(fileBytes).bytes;
  return base64Encode(bytes);
}

bool isImage(File file) {
  List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  String extension = file.uri.pathSegments.last.split('.').last.toLowerCase();
  return imageExtensions.contains(extension);
}

String formatFollowers(int followers) {
  if (followers >= 1000000000) {
    return '${(followers / 1000000000).toStringAsFixed(1)}B';
  } else if (followers >= 1000000) {
    return '${(followers / 1000000).toStringAsFixed(1)}M';
  } else if (followers >= 1000) {
    return '${(followers / 1000).toStringAsFixed(1)}K';
  } else {
    return followers.toString();
  }
}

List<ChatMessage> messageConvert(MessageModel element, Participant? selectUserInfo, AuthController authController) {
  List<ChatMessage> coverMessage = [];
  if (element.attachments != null && (element.attachments ?? []).isNotEmpty) {
    for (Attachment e in element.attachments ?? []) {
      if (e.type == 'image') {
        coverMessage.add(
          ChatMessage(
            id: element.id ?? '0',
            text: element.content ?? '',
            messageType: ChatMessageType.image,
            messageStatus: MessageStatus.viewed,
            isSender: authController.userDataModel.value.id == element.senderId,
            time: element.createdAt ?? DateTime.now(),
            otherUser: ChatUser(
              id: selectUserInfo?.id ?? "",
              name: selectUserInfo?.userName ?? '',
              imageUrl: selectUserInfo?.picture ?? '',
            ),
            data: e.data,
            replyMessage: element.replyTo == null
                ? null
                : ChatMessage(
                    id: element.replyTo?.id ?? '0',
                    text: element.replyTo?.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id == element.replyTo?.sender?.id,
                    time: element.replyTo?.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo?.id ?? "",
                      name: selectUserInfo?.userName ?? '',
                      imageUrl: selectUserInfo?.picture ?? '',
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
            isSender: authController.userDataModel.value.id == element.senderId,
            time: element.createdAt ?? DateTime.now(),
            otherUser: ChatUser(
              id: selectUserInfo?.id ?? "",
              name: selectUserInfo?.userName ?? '',
              imageUrl: selectUserInfo?.picture ?? '',
            ),
            data: e.data,
            replyMessage: element.replyTo == null
                ? null
                : ChatMessage(
                    id: element.replyTo?.id ?? '0',
                    text: element.replyTo?.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id == element.replyTo?.sender?.id,
                    time: element.replyTo?.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo?.id ?? "",
                      name: selectUserInfo?.userName ?? '',
                      imageUrl: selectUserInfo?.picture ?? '',
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
            isSender: authController.userDataModel.value.id == element.senderId,
            time: element.createdAt ?? DateTime.now(),
            otherUser: ChatUser(
              id: selectUserInfo?.id ?? "",
              name: selectUserInfo?.userName ?? '',
              imageUrl: selectUserInfo?.picture ?? '',
            ),
            data: e.data,
            replyMessage: element.replyTo == null
                ? null
                : ChatMessage(
                    id: element.replyTo?.id ?? '0',
                    text: element.replyTo?.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id == element.replyTo?.sender?.id,
                    time: element.replyTo?.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo?.id ?? "",
                      name: selectUserInfo?.userName ?? '',
                      imageUrl: selectUserInfo?.picture ?? '',
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
            isSender: authController.userDataModel.value.id == element.senderId,
            time: element.createdAt ?? DateTime.now(),
            otherUser: ChatUser(
              id: selectUserInfo?.id ?? "",
              name: selectUserInfo?.userName ?? '',
              imageUrl: selectUserInfo?.picture ?? '',
            ),
            data: e.data,
            replyMessage: element.replyTo == null
                ? null
                : ChatMessage(
                    id: element.replyTo?.id ?? '0',
                    text: element.replyTo?.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id == element.replyTo?.sender?.id,
                    time: element.replyTo?.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo?.id ?? "",
                      name: selectUserInfo?.userName ?? '',
                      imageUrl: selectUserInfo?.picture ?? '',
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
            isSender: authController.userDataModel.value.id == element.senderId,
            time: element.createdAt ?? DateTime.now(),
            otherUser: ChatUser(
              id: selectUserInfo?.id ?? "",
              name: selectUserInfo?.userName ?? '',
              imageUrl: selectUserInfo?.picture ?? '',
            ),
            data: e.data,
            replyMessage: element.replyTo == null
                ? null
                : ChatMessage(
                    id: element.replyTo?.id ?? '0',
                    text: element.replyTo?.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id == element.replyTo?.sender?.id,
                    time: element.replyTo?.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo?.id ?? "",
                      name: selectUserInfo?.userName ?? '',
                      imageUrl: selectUserInfo?.picture ?? '',
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
            isSender: authController.userDataModel.value.id == element.senderId,
            time: element.createdAt ?? DateTime.now(),
            otherUser: ChatUser(
              id: selectUserInfo?.id ?? "",
              name: selectUserInfo?.userName ?? '',
              imageUrl: selectUserInfo?.picture ?? '',
            ),
            data: null,
            replyMessage: element.replyTo == null
                ? null
                : ChatMessage(
                    id: element.replyTo?.id ?? '0',
                    text: element.replyTo?.content ?? '',
                    messageType: ChatMessageType.text,
                    messageStatus: MessageStatus.viewed,
                    isSender: authController.userDataModel.value.id == element.replyTo?.sender?.id,
                    time: element.replyTo?.createdAt ?? DateTime.now(),
                    otherUser: ChatUser(
                      id: selectUserInfo?.id ?? "",
                      name: selectUserInfo?.userName ?? '',
                      imageUrl: selectUserInfo?.picture ?? '',
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
        isSender: authController.userDataModel.value.id == element.senderId,
        time: element.createdAt ?? DateTime.now(),
        otherUser: ChatUser(
          id: selectUserInfo?.id ?? "",
          name: selectUserInfo?.userName ?? '',
          imageUrl: selectUserInfo?.picture ?? '',
        ),
        data: null,
      ),
    );
  }
  return coverMessage;
}
