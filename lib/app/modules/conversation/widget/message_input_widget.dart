import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_colors.dart';
import '../controller/conversation_controller.dart';

class ChatInputField extends StatelessWidget {
  final ConversationController messageController;
  const ChatInputField({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/emoji.png',
                              height: 25.h,
                              width: 25.w,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: messageController.messageController,
                                onChanged: (value) {
                                  messageController.typeMessageText.value =
                                      value;
                                },
                                style:
                                    context.theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Type message",
                                  hintStyle: context.theme.textTheme.bodyLarge,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => messageController.typeMessageText.isNotEmpty
                                  ? const Center()
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/icons/attachment.png',
                                          height: 25.h,
                                          width: 25.w,
                                        ),
                                        6.horizontalSpace,
                                        Image.asset(
                                          'assets/icons/location.png',
                                          height: 25.h,
                                          width: 25.w,
                                        ),
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            Obx(() {
              return GestureDetector(
                onTap: () {
                  messageController.sendMessage();
                },
                child: messageController.typeMessageText.isEmpty
                    ? CircleAvatar(
                        radius: 27,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.mic_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    : CircleAvatar(
                        radius: 27,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
