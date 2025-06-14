import 'dart:developer';

import 'package:alsat/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/message_model.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AudioMessage extends StatefulWidget {
  const AudioMessage({
    super.key,
    this.message,
    this.isReply = false,
  });
  final bool isReply;

  final ChatMessage? message;

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  AudioPlayerControllerManager audioPlayerControllerManager =
      Get.put(AudioPlayerControllerManager());
  late VoiceController voiceController;

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    voiceController = VoiceController(
      maxDuration: const Duration(minutes: 3),
      isFile: widget.message!.data.toString().contains('http') ? false : true,
      audioSrc: widget.message!.data.toString(),
      onComplete: () {},
      onPause: () {},
      onPlaying: () {
        audioPlayerControllerManager.playAudio(voiceController);
      },
      onError: (err) {
        log('message controller error $err');
      },
    );
    log('message controller ${voiceController.audioSrc}');
    audioPlayerControllerManager.addController(voiceController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          VoiceMessageView(
            activeSliderColor: widget.isReply
                ? Colors.black
                : widget.message!.isSender
                    ? Colors.white
                    : AppColors.primary,
            circlesColor: widget.isReply
                ? Colors.black
                : widget.message!.isSender
                    ? Colors.white
                    : AppColors.primary,
            refreshIcon: const Icon(Icons.refresh, color: AppColors.primary),
            pauseIcon: Icon(
              Icons.pause_rounded,
              color: widget.isReply
                  ? Colors.white
                  : !widget.message!.isSender
                      ? Colors.white
                      : AppColors.primary,
            ),
            playIcon: Icon(
              Icons.play_arrow_rounded,
              color: widget.isReply
                  ? Colors.white
                  : !widget.message!.isSender
                      ? Colors.white
                      : AppColors.primary,
            ),
            stopDownloadingIcon: Icon(
              Icons.close,
              color: widget.isReply
                  ? Colors.black
                  : !widget.message!.isSender
                      ? Colors.white
                      : AppColors.primary,
            ),
            circlesTextStyle: TextStyle(
                color: widget.isReply
                    ? Colors.white
                    : !widget.message!.isSender
                        ? Colors.white
                        : AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold),
            counterTextStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: widget.isReply
                  ? Colors.black
                  : widget.message!.isSender
                      ? Colors.white
                      : AppColors.primary,
            ),
            backgroundColor: widget.isReply
                ? Colors.white
                : widget.message!.isSender
                    ? context.theme.primaryColor
                    : Colors.white,
            controller: voiceController,
            innerPadding: 12,
            cornerRadius: 20,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              DateFormat('hh:mm').format(widget.message!.time.toLocal()),
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: widget.message!.isSender ? Colors.white : null,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerControllerManager extends GetxController {
  List<VoiceController> controllers = [];

  void playAudio(VoiceController controller) {
    for (var ctrl in controllers) {
      if (ctrl != controller) {
        ctrl.stopPlaying();
      }
    }
  }

  void addController(VoiceController controller) {
    controllers.contains(controller) ? null : controllers.add(controller);
  }

  void removeController(VoiceController controller) {
    controllers.contains(controller) ? controllers.remove(controller) : null;
  }
}
