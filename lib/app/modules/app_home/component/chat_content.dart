// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/conversation/model/conversation_messages_res.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../common/const/image_path.dart';
import '../../../components/custom_footer_widget.dart';
import '../../../components/custom_header_widget.dart';
import '../../../components/network_image_preview.dart';
import '../../conversation/controller/conversation_controller.dart';
import '../../conversation/view/message_view.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversationController conversationController = Get.find();
    final AuthController authController = Get.find();
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: CustomHeaderWidget(),
      footer: CustomFooterWidget(),
      controller: conversationController.conversationRefreshController,
      onRefresh: conversationController.conversationRefresh,
      onLoading: conversationController.conversationLoading,
      // onRefresh: () async {
      // conversationController.getConversations();
      // },
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ).copyWith(top: 0),
        children: [
          Obx(() {
            // {message_id: b1333db6-6c92-4c67-809a-c14d8d057f85, type: chat/inbox, sender_id: eac7a365-52cc-4b79-a2f8-caea1a348175, chat_id: e5da1fd9-14ec-4a24-a4fe-368b8ab30b10}
            return Skeletonizer(
              enabled: conversationController.isConversationLoading.value,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: conversationController.isConversationLoading.value
                    ? 10
                    : conversationController.conversationList.length,
                itemBuilder: (context, index) {
                  var conversation = conversationController.isConversationLoading.value
                      ? null
                      : conversationController.conversationList[index];
                  Participant? participant = conversation?.participants
                      ?.firstWhereOrNull((e) => e.id != authController.userDataModel.value.id);
                  return Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Get.theme.disabledColor.withOpacity(.05),
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          log(conversation?.id.toString() ?? '');
                          conversationController.conversationList[index].notReadedCount = 0;
                          conversationController.conversationList.refresh();
                          Get.to(
                            MessagesScreen(
                              conversation: conversation!,
                            ),
                            transition: Transition.fadeIn,
                          );
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        leading: CircleAvatar(
                          radius: 20.r,
                          child: CircleAvatar(
                            radius: 18.r,
                            child: (conversation?.isAdminChat ?? false)
                                ? Image.asset("assets/icons/admin.png")
                                : NetworkImagePreview(
                                    radius: 30.r,
                                    url: participant?.picture ?? "",
                                    height: 44.h,
                                    width: 44.w,
                                    error: Image.asset(userDefaultIcon),
                                  ),
                          ),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (conversation?.isAdminChat ?? false) ? 'Teklip Admin' : '${participant?.userName}',
                              style: regular.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            if (conversation?.isAdminChat ?? false)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 18.sp,
                                ),
                              )
                          ],
                        ),
                        trailing: (conversation?.notReadedCount ?? 0) <= 0
                            ? null
                            : CircleAvatar(
                                radius: 14.r,
                                backgroundColor: Get.theme.primaryColor.withOpacity(.5),
                                child: CircleAvatar(
                                  radius: 13.r,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 13.r,
                                    backgroundColor: Get.theme.disabledColor.withOpacity(.05),
                                    child: Text(
                                      (conversation?.notReadedCount ?? 0).toString(),
                                      style: regular.copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Get.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        subtitle: conversationController.isConversationLoading.value
                            ? const Text('Last Message Loading')
                            : conversation?.lastMessage == null ||
                                    ((conversation?.lastMessage?.content ?? "").isEmpty &&
                                        (conversation?.lastMessage?.attachments?.isEmpty ?? true))
                                ? Text(
                                    "Join at ${timeAgo(DateTime.tryParse(conversation?.createdAt ?? "") ?? DateTime.now())}",
                                    style: regular.copyWith(
                                      fontSize: 11.sp,
                                      color: Get.theme.disabledColor,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          (conversation?.lastMessage?.content?.isEmpty ?? true)
                                              ? "${conversation?.lastMessage?.attachments?.firstOrNull?.type ?? 'No'} Message Sent"
                                              : conversation?.lastMessage?.content ?? "",
                                          style: regular.copyWith(
                                            fontSize: 11.sp,
                                            color: Get.theme.disabledColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        " at ${timeAgo(conversation?.lastMessage?.createdAt ?? DateTime.now())}",
                                        style: regular.copyWith(
                                          fontSize: 11.sp,
                                          color: Get.theme.disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),
                      ));
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
