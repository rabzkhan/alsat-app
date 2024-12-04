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
          VoiceMessageView(
            controller: VoiceController(
              maxDuration: const Duration(seconds: 10),
              isFile: false,
              audioSrc:
                  'https://dl.solahangs.com/Music/1403/02/H/128/Hiphopologist%20-%20Shakkak%20%28128%29.mp3',
              onComplete: () {
                /// do something on complete
              },
              onPause: () {
                /// do something on pause
              },
              onPlaying: () {
                /// do something on playing
              },
              onError: (err) {
                /// do somethin on error
              },
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
