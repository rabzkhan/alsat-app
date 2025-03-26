import 'package:alsat/app/common/const/image_path.dart';
import 'package:alsat/app/components/network_image_preview.dart';
import 'package:alsat/app/modules/conversation/controller/conversation_controller.dart';
import 'package:alsat/app/modules/conversation/controller/message_controller.dart';
import 'package:alsat/app/modules/conversation/widget/message_dot.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    MessageController messageController = Get.put(MessageController(),
        tag:
            '${Get.find<ConversationController>().selectConversation.value?.id}');
    Widget messageConvertByType(ChatMessage message, {bool isReply = false}) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message, isReply: isReply);
        case ChatMessageType.image:
          return ImageMessage(message: message, isReply: isReply);
        case ChatMessageType.map:
          return MapMessage(message: message, isReply: isReply);
        case ChatMessageType.audio:
          return AudioMessage(message: message, isReply: isReply);
        case ChatMessageType.video:
          return VideoMessage(message: message, isReply: isReply);
        case ChatMessageType.post:
          return PostMessageTile(message: message, isReply: isReply);
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) {
                messageController.selectReplyMessage.value = message;
              },
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.primary,
              icon: Icons.reply,
              label: 'Reply',
            ),
          ],
        ),
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.heavyImpact();
            messageController.selectMessage.value = message;
          },
          onTap: () {
            messageController.selectMessage.value = null;
          },
          child: Row(
            mainAxisAlignment: message.isSender
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isSender) ...[
                CircleAvatar(
                  radius: 20,
                  child: NetworkImagePreview(
                    radius: 40.r,
                    url: message.otherUser.imageUrl,
                    height: 40.r,
                    width: 40.r,
                    error: Image.asset(userDefaultIcon),
                  ),
                ),
                const SizedBox(width: 16.0 / 2),
              ],
              Flexible(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: !message.isSender
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  if (message.replyMessage != null)
                    Column(
                      crossAxisAlignment: !message.isSender
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Replayed Message ${message.replyMessage?.isSender == true ? 'From You' : 'From ${message.replyMessage?.otherUser.name}'}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.r),
                              topLeft: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r),
                            ),
                          ),
                          child: messageConvertByType(message.replyMessage!,
                              isReply: true),
                        ),
                      ],
                    ),
                  messageConvertByType(message),
                ],
              )),
              if (message.isSender)
                MessageStatusDot(status: message.messageStatus)
            ],
          ),
        ),
      ),
    );
  }
}
