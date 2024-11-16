import 'package:alsat/app/modules/conversation/view/conversation_view.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';
import '../../../components/network_image_preview.dart';
import '../../conversation/controller/conversation_controller.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversationController conversationController = Get.find();
    return RefreshIndicator(
      onRefresh: () async {
        conversationController.getConversations();
      },
      child: ListView(
        // physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        children: [
          Text(
            'Chat',
            style: regular.copyWith(
              fontSize: 16.sp,
            ),
          ),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: conversationController.conversationList.length,
              itemBuilder: (context, index) {
                var conversation =
                    conversationController.conversationList[index];
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
                      Get.to(
                        ConversationView(
                          conversation: conversation,
                        ),
                        transition: Transition.fadeIn,
                      );
                      // Get.to(const ConversationView());
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    leading: CircleAvatar(
                      radius: 20.r,
                      child: CircleAvatar(
                        radius: 18.r,
                        child: NewworkImagePreview(
                          radius: 30.r,
                          url:
                              conversation.participants?.firstOrNull?.picture ??
                                  "",
                          height: 44.h,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${conversation.participants?.lastOrNull?.userName}',
                          style: regular.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        5.horizontalSpace,
                        CircleAvatar(
                          radius: 2.r,
                          backgroundColor: Get.theme.textTheme.bodyLarge!.color,
                        ),
                        5.horizontalSpace,
                        Text(
                          timeAgo(conversation.lastMessage?.createdAt ??
                              DateTime.now()),
                          style: regular.copyWith(
                            fontSize: 10.sp,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    //   title: Text('Alexander'),
                    subtitle: conversation.lastMessage == null
                        ? null
                        : Text(
                            '${conversation.lastMessage?.content}',
                            style: regular.copyWith(
                              fontSize: 12.sp,
                              color: Get.theme.disabledColor,
                            ),
                          ),
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }
}
