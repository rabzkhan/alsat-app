import 'package:alsat/app/modules/conversation/model/conversation_messages_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alsat/l10n/app_localizations.dart';
import '../controller/conversation_controller.dart';

Future<void> showUserBlockBottomSheet({
  required Participant participant,
  required ConversationController conversationController,
  bool isBlocked = true,
}) {
  final localLanguage = AppLocalizations.of(Get.context!)!;
  return showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(.1),
      context: Get.context!,
      builder: (context) {
        return Container(
          height: Get.height * .5,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/icons/block.png',
                height: 80.h,
              ),
              ListTile(
                leading: Icon(
                    isBlocked ? Icons.block_rounded : Icons.messenger_outline),
                title: Text(
                    '${localLanguage.prevents} ${isBlocked ? localLanguage.unwanted : localLanguage.wanted} ${localLanguage.contact}'),
                subtitle:
                    Text(localLanguage.they_wont_be_able_to_send_you_messages),
              ),
              ListTile(
                leading: const Icon(Icons.miscellaneous_services_sharp),
                title: Text(
                    '${localLanguage.they} ${isBlocked ? localLanguage.wont : localLanguage.want} ${localLanguage.be_notified}'),
                subtitle:
                    Text(localLanguage.we_wont_tell_them_if_you_block_them),
              ),
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
                          isBlocked
                              ? localLanguage.block_user
                              : localLanguage.unblock,
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                );
              }),
              CupertinoButton(
                child: Text(
                  localLanguage.cancel,
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
