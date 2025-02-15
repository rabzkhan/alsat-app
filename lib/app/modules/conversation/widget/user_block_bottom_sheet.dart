import 'package:alsat/app/modules/conversation/model/conversation_messages_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/conversation_controller.dart';

Future<void> showUserBlockBottomSheet({
  required Participant participant,
  required ConversationController conversationController,
  bool isBlocked = true,
}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(.1),
      context: Get.context!,
      builder: (context) {
        return Container(
          height: Get.height * .5,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              20.verticalSpace,
              Image.asset(
                'assets/icons/block.png',
                height: 80.h,
              ),
              10.verticalSpace,
              ListTile(
                leading: Icon(
                    isBlocked ? Icons.block_rounded : Icons.messenger_outline),
                title: Text(
                    'Prevents ${isBlocked ? "unwanted" : "wanted"} contact'),
                subtitle:
                    const Text('They won\'t be able to send you messages'),
              ),
              ListTile(
                leading: const Icon(Icons.miscellaneous_services_sharp),
                title: Text('They ${isBlocked ? "won't" : 'want'} be notified'),
                subtitle: const Text(
                    'We won\'t tell the, if you block them. Uncblock them to send messages'),
              ),
              20.verticalSpace,
              Obx(() {
                return CupertinoButton(
                  color: Colors.red,
                  onPressed: conversationController.isBlockUser.value
                      ? null
                      : () {
                          conversationController.blockUser(
                            conversationController
                                    .selectConversation.value?.id ??
                                '',
                            participant.id ?? '',
                            isBlock: isBlocked,
                          );
                        },
                  child: conversationController.isBlockUser.value
                      ? const CupertinoActivityIndicator()
                      : Text(
                          isBlocked ? 'Block' : "Unblock",
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                );
              }),
              10.verticalSpace,
              CupertinoButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 14.sp),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      });
}
