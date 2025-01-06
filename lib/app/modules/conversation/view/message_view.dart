import 'dart:developer';

import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/app/modules/product/view/client_profile_view.dart';
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
import '../controller/message_controller.dart';
import '../model/conversation_messages_res.dart';
import '../model/conversations_res.dart';
import '../widget/message_input_widget.dart';
import '../widget/message_side_option.dart';
import '../widget/message_tile.dart';

class MessagesScreen extends StatefulWidget {
  final ConversationModel conversation;
  const MessagesScreen({super.key, required this.conversation});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ConversationController conversationController = Get.find();
  late MessageController messageController;
  AuthController authController = Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    messageController =
        Get.put(MessageController(), tag: '${widget.conversation.id}');

    Participant? participant =
        (widget.conversation.participants ?? []).firstWhereOrNull((e) {
      return e.id != authController.userDataModel.value.id;
    });
    log('participant: ${participant?.id}');
    messageController.checkUserActiveLive(userID: participant?.id ?? "");
    conversationController.selectConversation.value = widget.conversation;
    conversationController.getConversationsMessages();
    conversationController.typeMessageText.value = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (messageController.selectMessageId.value != null) {
          messageController.selectMessageId.value = null;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        key: _key,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60.h,
          actions: [
            IconButton(
              onPressed: () {
                _key.currentState!.openEndDrawer();
              },
              icon: Icon(
                Icons.more_vert_sharp,
                size: 30.r,
                color: bold.color!.withOpacity(.5),
              ),
            )
          ],
          title: Obx(() {
            return InkWell(
              onTap: () {
                ProductDetailsController productDetailsController = Get.put(
                    ProductDetailsController(),
                    tag: conversationController
                        .selectConversation.value?.participants
                        ?.firstWhereOrNull((e) =>
                            e.id != authController.userDataModel.value.id)
                        ?.id);

                productDetailsController.isFetchUserLoading.value = false;
                Get.to(
                  () => ClientProfileView(
                    userId: (conversationController
                                .selectConversation.value?.participants
                                ?.firstWhereOrNull((e) =>
                                    e.id !=
                                    authController.userDataModel.value.id)
                                ?.id ??
                            '')
                        .toString(),
                    productDetailsController: productDetailsController,
                  ),
                  transition: Transition.fadeIn,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: NetworkImagePreview(
                      radius: 30.r,
                      url: conversationController
                              .selectConversation.value?.participants
                              ?.firstWhereOrNull((e) =>
                                  e.id != authController.userDataModel.value.id)
                              ?.picture ??
                          "",
                      height: 44.h,
                    ),
                  ),
                  8.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${conversationController.selectConversation.value?.participants?.firstWhereOrNull((e) => e.id != authController.userDataModel.value.id)?.userName}',
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
              ),
            );
          }),
        ),
        endDrawer: MessageSideOption(
          conversationController: conversationController,
          authController: authController,
          _key,
          participant: (conversationController
              .selectConversation.value?.participants
              ?.firstWhereOrNull(
                  (e) => e.id != authController.userDataModel.value.id)),
        ),
        body: GestureDetector(
          onTap: () {
            messageController.selectMessageId.value = null;
            FocusScope.of(context).unfocus();
          },
          child: Column(
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
                    child: conversationController
                            .isConversationMessageLoading.value
                        ? const Center(child: CupertinoActivityIndicator())
                        : ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            reverse: true,
                            controller: conversationController.scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                conversationController.coverMessage.length,
                            itemBuilder: (context, index) => MessageTile(
                              message:
                                  conversationController.coverMessage[index],
                            ),
                          ),
                  );
                }),
              ),
              Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: messageController.selectMessageId.value == null
                      ? ChatInputField(
                          messageController: conversationController)
                      : Container(
                          height: 70.h,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0 / 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.reply_outlined,
                                      color: Colors.white,
                                      size: 25.r,
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      'Reply',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    conversationController.deleteMessage(
                                        messageController
                                            .selectMessageId.value!);
                                    messageController.selectMessageId.value =
                                        null;
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.delete_sharp,
                                        color: Colors.white,
                                        size: 25.r,
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
