import 'dart:developer';

import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/app/modules/product/view/client_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../components/network_image_preview.dart';
import '../../authentication/controller/auth_controller.dart';
import '../controller/conversation_controller.dart';
import '../controller/message_controller.dart';
import '../model/conversation_messages_res.dart';
import '../model/conversations_res.dart';
import '../widget/message_input_widget.dart';
import '../widget/message_tile.dart';
import '../widget/user_block_bottom_sheet.dart';
import '../widget/user_report_bottom_sheet.dart';

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
    messageController.readAllUnSeenMessages(widget.conversation.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (messageController.selectMessage.value != null) {
          messageController.selectMessage.value = null;
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
            CustomPopup(
              backgroundColor: AppColors.primary,
              showArrow: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              barrierColor: Colors.transparent,
              arrowColor: Colors.black,
              contentDecoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.4),
                    blurRadius: 10,
                    spreadRadius: .5,
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoListTile.notched(
                      onTap: () {
                        // Get.back();
                        showUserBlockBottomSheet(
                          participant: (conversationController
                              .selectConversation.value?.participants
                              ?.firstWhereOrNull((e) =>
                                  e.id !=
                                  authController.userDataModel.value.id))!,
                          conversationController: conversationController,
                        ).then((onValue) {
                          widget.conversation.haveBlocked = true;
                          setState(() {});
                        });
                      },
                      title: Text(
                        'Block User',
                        style: regular.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      leading: const Icon(
                        Icons.block_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    CupertinoListTile.notched(
                      onTap: () {
                        // Get.back();
                        showUserReportBottomSheet(
                          participant: (conversationController
                              .selectConversation.value?.participants
                              ?.firstWhereOrNull((e) =>
                                  e.id !=
                                  authController.userDataModel.value.id))!,
                          conversationController: conversationController,
                        );
                      },
                      title: Text(
                        'Report',
                        style: regular.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      leading: const Icon(
                        Icons.report,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              child: Icon(
                Icons.more_vert_sharp,
                size: 30.r,
                color: bold.color!.withOpacity(.5),
              ),
            ),
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
                      error: (widget.conversation.isAdminChat ?? false)
                          ? Image.asset("assets/icons/admin.png")
                          : Image.asset(userDefaultIcon),
                    ),
                  ),
                  8.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (widget.conversation.isAdminChat ?? false)
                                ? 'Alsat Admin'
                                : '${conversationController.selectConversation.value?.participants?.firstWhereOrNull((e) => e.id != authController.userDataModel.value.id)?.userName}',
                            style: bold.copyWith(
                              fontSize: 15.sp,
                            ),
                          ),
                          if (widget.conversation.isAdminChat ?? false)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 18.sp,
                              ),
                            )
                        ],
                      ),
                      1.verticalSpace,
                      Obx(() {
                        return Text(
                          messageController.isOnlineUser.value
                              ? 'Active Now'
                              : 'Last seen ${DateFormat('hh:mm a dd MMM').format(messageController.lastSeen.value ?? DateTime.now())}',
                          style: regular.copyWith(
                            fontSize: 11.sp,
                          ),
                        );
                      })
                    ],
                  )
                ],
              ),
            );
          }),
        ),
        body: GestureDetector(
          onTap: () {
            messageController.selectMessage.value = null;
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
                        : !conversationController
                                    .isConversationMessageLoading.value &&
                                conversationController.coverMessage.isEmpty
                            ? const NoDataWidget(
                                isShowIcon: false, title: 'No Messages')
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                reverse: true,
                                controller:
                                    conversationController.scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    conversationController.coverMessage.length,
                                itemBuilder: (context, index) => MessageTile(
                                  message: conversationController
                                      .coverMessage[index],
                                ),
                              ),
                  );
                }),
              ),
              ((widget.conversation.haveBlocked ?? false) ||
                      (widget.conversation.isBlocked ?? false))
                  ? Container(
                      margin: EdgeInsets.only(top: 10.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 12.h,
                      ),
                      color: Colors.grey.shade300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'You have blocked this user',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          2.verticalSpace,
                          Text(
                            "You can't send message to this user",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          10.verticalSpace,
                          if ((widget.conversation.haveBlocked ?? false))
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    color: Colors.grey,
                                    child: const Text('UnBlock'),
                                    onPressed: () {
                                      showUserBlockBottomSheet(
                                        isBlocked: false,
                                        participant: (conversationController
                                            .selectConversation
                                            .value
                                            ?.participants
                                            ?.firstWhereOrNull((e) =>
                                                e.id !=
                                                authController
                                                    .userDataModel.value.id))!,
                                        conversationController:
                                            conversationController,
                                      ).then((value) {
                                        widget.conversation.haveBlocked = false;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          10.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                  color: Colors.grey,
                                  child: const Text('Report'),
                                  onPressed: () {
                                    showUserReportBottomSheet(
                                      participant: (conversationController
                                          .selectConversation
                                          .value
                                          ?.participants
                                          ?.firstWhereOrNull((e) =>
                                              e.id !=
                                              authController
                                                  .userDataModel.value.id))!,
                                      conversationController:
                                          conversationController,
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Obx(() {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: messageController.selectMessage.value == null
                            ? ChatInputField(
                                messageController: messageController,
                                conversationController: conversationController)
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
                                      child: GestureDetector(
                                        onTap: () {
                                          messageController
                                                  .selectReplyMessage.value =
                                              messageController
                                                  .selectMessage.value;
                                        },
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
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          conversationController.deleteMessage(
                                              messageController
                                                  .selectMessage.value!.id);
                                          messageController
                                              .selectMessage.value = null;
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
