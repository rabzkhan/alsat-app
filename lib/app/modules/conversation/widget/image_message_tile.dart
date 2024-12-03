import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/network_image_preview.dart';
import '../model/message_model.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    this.message,
  });

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: message!.isSender ? context.theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          NewworkImagePreview(
            url: message!.data,
            height: 100,
          ),
          5.verticalSpace,
          Text(
            DateFormat('hh:mm').format(message!.time),
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: message!.isSender ? Colors.white : null,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
