import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pod_player/pod_player.dart';
import '../model/message_model.dart';

class VideoMessage extends StatefulWidget {
  const VideoMessage({
    super.key,
    this.message,
    this.isReply = false,
  });
  final bool isReply;

  final ChatMessage? message;

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  late PodPlayerController podVideoController;
  VideoPlayerControllerManager videoPlayerControllerManager =
      Get.put(VideoPlayerControllerManager());

  void playVideo() {
    podVideoController = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(widget.message?.data ?? ''),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
        isLooping: false,
      ),
    )..initialise().then((_) {
        log('podVideoController: $podVideoController');
        videoPlayerControllerManager.addController(podVideoController);
      });
  }

  @override
  void initState() {
    super.initState();
    playVideo();
  }

  @override
  void dispose() {
    videoPlayerControllerManager.removeController(podVideoController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .6,
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0 * 0.75, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isReply
            ? Colors.transparent
            : widget.message!.isSender
                ? context.theme.primaryColor.withOpacity(.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Video player widget
          PodVideoPlayer(
            controller: podVideoController,
            overlayBuilder: (options) {
              return GestureDetector(
                onTap: () {
                  log('Play video');
                  videoPlayerControllerManager.playVideo(podVideoController);
                },
                child: Opacity(
                  opacity: options.isOverlayVisible ? 1 : 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                        Text(
                          'Tap to play',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          5.verticalSpace,
          Text(
            DateFormat('hh:mm').format(widget.message!.time),
            style: context.theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerControllerManager extends GetxController {
  List<PodPlayerController> controllers = [];

  void playVideo(PodPlayerController controller) {
    log('Play video : ${controllers.length}');
    for (var ctrl in controllers) {
      if (ctrl != controller) {
        ctrl.pause();
      }
    }
    // Play the selected video
    controller.play();
  }

  void addController(PodPlayerController controller) {
    controllers.add(controller);
  }

  void removeController(PodPlayerController controller) {
    controllers.remove(controller);
  }
}
