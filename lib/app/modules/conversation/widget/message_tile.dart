import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/conversation/controller/conversation_controller.dart';
import 'package:alsat/app/modules/conversation/widget/message_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../model/message_model.dart';
import 'audio_message_tile.dart';
import 'image_message_tile.dart';
import 'map_message_tile.dart';
import 'post_message_tile.dart';
import 'text_message_tile.dart';
import 'video_message_tile.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageConvert(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.image:
          return ImageMessage(message: message);
        case ChatMessageType.map:
          return MapMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.video:
          return VideoMessage(message: message);
        case ChatMessageType.post:
          return PostMessageTile(message: message);
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              radius: 20,
              child: NetworkImagePreview(
                radius: 40.r,
                url: message.otherUser.imageUrl,
                height: 40.r,
              ),
            ),
            const SizedBox(width: 16.0 / 2),
          ],
          Flexible(child: messageConvert(message)),
          if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}
