import 'package:alsat/app/modules/conversation/view/conversation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_text_theme.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
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
        ...List.generate(10, (index) {
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
                Get.to(const ConversationView());
                // Get.to(const ConversationView());
              },
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              leading: const CircleAvatar(),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Alexander',
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
                    '1h',
                    style: regular.copyWith(
                      fontSize: 14.sp,
                      color: Get.theme.disabledColor,
                    ),
                  ),
                ],
              ),
              //   title: Text('Alexander'),
              subtitle: const Text('We no longer need to talk about Kevin'),

            ),
          );
        }),
      ],
    );
  }
}
