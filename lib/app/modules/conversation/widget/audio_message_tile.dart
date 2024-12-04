import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/message_model.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({
    super.key,
    this.message,
  });

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          VoiceMessageView(
            activeSliderColor: Colors.white,
            circlesColor: Colors.white,
            refreshIcon: const Icon(Icons.refresh, color: AppColors.primary),
            pauseIcon:
                const Icon(Icons.pause_rounded, color: AppColors.primary),
            playIcon:
                const Icon(Icons.play_arrow_rounded, color: AppColors.primary),
            stopDownloadingIcon:
                const Icon(Icons.close, color: AppColors.primary),
            circlesTextStyle: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold),
            counterTextStyle: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
            backgroundColor:
                message!.isSender ? context.theme.primaryColor : Colors.white,
            controller: VoiceController(
              maxDuration: const Duration(seconds: 10),
              isFile: message!.data.toString().contains('http') ? false : true,
              audioSrc: message!.data.toString(),
              onComplete: () {},
              onPause: () {},
              onPlaying: () {},
              onError: (err) {},
            ),
            innerPadding: 12,
            cornerRadius: 20,
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
