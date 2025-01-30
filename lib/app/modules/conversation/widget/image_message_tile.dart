import 'dart:io';

import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/image_preview.dart';
import '../../../components/network_image_preview.dart';
import '../model/message_model.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    this.message,
    this.isReply = false,
  });
  final bool isReply;
  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ImagePreviewView(
            imageProvider:
                message!.data.toString().toLowerCase().contains('http')
                    ? NetworkImage(message!.data.toString())
                    : FileImage(File(message!.data.toString())),
          ),
          transition: Transition.cupertinoDialog,
        );
      },
      child: Container(
        width: Get.width * .7,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0 * 0.75,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isReply
              ? Colors.transparent
              : message!.isSender
                  ? Colors.transparent
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message!.data.toString().toLowerCase().contains('http')
                ? NetworkImagePreview(
                    radius: 10.r,
                    url: message!.data,
                  )
                : Image.file(File(message!.data.toString())),
            5.verticalSpace,
            Text(
              DateFormat('hh:mm').format(message!.time.toLocal()),
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: isReply
                    ? Colors.black
                    : message!.isSender
                        ? AppColors.primary
                        : null,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
