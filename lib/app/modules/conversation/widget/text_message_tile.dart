import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/message_model.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    super.key,
    this.message,
    this.isReply = false,
  });

  final ChatMessage? message;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: message!.isSender ? 50 : 0,
        right: message!.isSender ? 0 : 50,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isReply
            ? Colors.transparent
            : message!.isSender
                ? context.theme.primaryColor
                : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message!.text,
            style: context.theme.textTheme.bodyLarge?.copyWith(
              color: isReply
                  ? Colors.black45
                  : message!.isSender
                      ? Colors.white
                      : null,
              fontSize: 15.sp,
            ),
          ),
          Text(
            DateFormat('hh:mm').format(message!.time.toLocal()),
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: isReply
                  ? Colors.black38
                  : message!.isSender
                      ? Colors.white
                      : null,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
