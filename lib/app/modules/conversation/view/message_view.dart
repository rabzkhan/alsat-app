import 'dart:developer';

import 'package:alsat/app/components/no_data_widget.dart';
import 'package:alsat/app/modules/product/controller/product_details_controller.dart';
import 'package:alsat/app/modules/product/model/product_post_list_res.dart';
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
import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagesScreen extends StatefulWidget {
  final ProductModel? productModel;
  final ConversationModel conversation;
  const MessagesScreen(
      {super.key, required this.conversation, this.productModel});

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
    messageController.selectProductModel.value = widget.productModel;
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
    final localLanguage = AppLocalizations.of(Get.context!)!;

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
                          if (conversationController.isBlockingSuccess.value) {
                            widget.conversation.haveBlocked = true;
                            setState(() {});
                          }
                        });
                      },
                      title: Text(
                        localLanguage.block_user,
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
                        localLanguage.report,
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
                    isFromMessage: true,
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
              child: SizedBox(
                width: Get.width * .8,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: NetworkImagePreview(
                        radius: 30.r,
                        url: conversationController
                                .selectConversation.value?.participants
                                ?.firstWhereOrNull((e) =>
                                    e.id !=
                                    authController.userDataModel.value.id)
                                ?.picture ??
                            "",
                        height: 44.h,
                        width: 44.w,
                        error: (widget.conversation.isAdminChat ?? false)
                            ? Image.asset("assets/icons/admin.png")
                            : Image.asset(userDefaultIcon),
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Column(
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
                                  ? localLanguage.active_now
                                  : '${localLanguage.last_seen} ${DateFormat('hh:mm a dd MMM', Get.locale!.languageCode).format(messageController.lastSeen.value ?? DateTime.now())}',
                              style: regular.copyWith(
                                fontSize: 11.sp,
                              ),
                            );
                          })
                        ],
                      ),
                    )
                  ],
                ),
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
                    header: CusomHeaderWidget(),
                    footer: CustomFooterWidget(),
                    controller: conversationController.refreshMessageController,
                    onRefresh: conversationController.onRefreshMessage,
                    onLoading: conversationController.onLoadingMessage,
                    child: conversationController
                            .isConversationMessageLoading.value
                        ? const Center(child: CupertinoActivityIndicator())
                        : conversationController.coverMessage.isEmpty
                            ? NoDataWidget(
                                isShowIcon: false,
                                title: localLanguage.no_messages,
                              )
                            : AnimatedList(
                                key: conversationController.animatedListKey,
                                reverse: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                controller:
                                    conversationController.scrollController,
                                physics: const BouncingScrollPhysics(),
                                initialItemCount:
                                    conversationController.coverMessage.length,
                                itemBuilder: (context, index, animation) {
                                  final message = conversationController
                                      .coverMessage[index];
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    child: MessageTile(message: message),
                                  );
                                },
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
                            localLanguage.you_have_blocked_this_user,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          2.verticalSpace,
                          Text(
                            localLanguage.you_cant_send_message_to_this_user,
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
                                    color: Colors.green,
                                    child: Text(
                                      localLanguage.unblock,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
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
                                  child: Text(
                                    localLanguage.report,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
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
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return messageController
                                                .selectProductModel.value ==
                                            null
                                        ? Center()
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10.r,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                messageController
                                                            .selectProductModel
                                                            .value
                                                            ?.media
                                                            ?.firstOrNull
                                                            ?.name !=
                                                        null
                                                    ? NetworkImagePreview(
                                                        previewImage: true,
                                                        radius: 10.r,
                                                        url: messageController
                                                                .selectProductModel
                                                                .value
                                                                ?.media
                                                                ?.firstOrNull
                                                                ?.name ??
                                                            '',
                                                        height: 50.h,
                                                        width: 60.w,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Icon(Icons.pix_rounded),
                                                10.horizontalSpace,
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      maxLines: 1,
                                                      '${messageController.selectProductModel.value?.title}',
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      maxLines: 1,
                                                      '${messageController.selectProductModel.value?.priceInfo?.price}',
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                                InkWell(
                                                  onTap: () {
                                                    messageController
                                                        .selectProductModel
                                                        .value = null;
                                                  },
                                                  child: Icon(
                                                      CupertinoIcons.xmark),
                                                )
                                              ],
                                            ),
                                          );
                                  }),
                                  ChatInputField(
                                    messageController: messageController,
                                    conversationController:
                                        conversationController,
                                  ),
                                ],
                              )
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
                                              localLanguage.reply,
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
                                              localLanguage.delete,
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
