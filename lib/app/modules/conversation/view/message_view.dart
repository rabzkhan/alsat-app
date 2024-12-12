import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../components/network_image_preview.dart';
import '../../authentication/controller/auth_controller.dart';
import '../controller/conversation_controller.dart';
import '../model/conversations_res.dart';
import '../widget/message_input_widget.dart';
import '../widget/message_tile.dart';

class MessagesScreen extends StatefulWidget {
  final ConversationModel conversation;
  const MessagesScreen({super.key, required this.conversation});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ConversationController conversationController = Get.find();

  AuthController authController = Get.find();
  @override
  void initState() {
    conversationController.selectConversation.value = widget.conversation;
    conversationController.getConversationsMessages();
    conversationController.typeMessageText.value = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60.h,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_sharp,
              size: 30.r,
              color: bold.color!.withOpacity(.5),
            ),
          )
        ],
        title: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: NewworkImagePreview(
                  radius: 30.r,
                  url: conversationController.selectConversation.value
                          ?.participants?.firstOrNull?.picture ??
                      "",
                  height: 44.h,
                ),
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${conversationController.selectConversation.value?.participants?.lastOrNull?.userName}',
                    style: bold.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),
                  1.verticalSpace,
                  Text(
                    'Active Now',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                    ),
                  )
                ],
              )
            ],
          );
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return SmartRefresher(
                physics: const BouncingScrollPhysics(),
                enablePullDown: false,
                enablePullUp: true,
                // footer: messageLoad,
                controller: conversationController.refreshMessageController,
                onRefresh: conversationController.onRefreshMessage,
                onLoading: conversationController.onLoadingMessage,
                child: conversationController.isConversationMessageLoading.value
                    ? const Center(child: CupertinoActivityIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        reverse: true,
                        controller: conversationController.scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: conversationController.coverMessage.length,
                        itemBuilder: (context, index) => MessageTile(
                          message: conversationController.coverMessage[index],
                        ),
                      ),
              );
            }),
          ),
          ChatInputField(messageController: conversationController)
        ],
      ),
    );
  }
}
