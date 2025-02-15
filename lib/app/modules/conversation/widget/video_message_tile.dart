import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../model/message_model.dart';
import '../view/message_video_player.dart';

class VideoMessage extends StatefulWidget {
  final bool isReply;

  final ChatMessage? message;
  const VideoMessage({super.key, required this.isReply, this.message});

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  VideoPlayerController? videoPlayerController;
  Uint8List? videoFile;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      videoFile = await VideoThumbnail.thumbnailData(
        video: widget.message?.data ?? '',
        imageFormat: ImageFormat.JPEG,
        maxHeight: 400,
        quality: 100,
      );
      setState(() {});
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.message?.data ?? ''),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );
      await videoPlayerController?.initialize();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.message?.data ?? '',
      child: GestureDetector(
        onTap: () {
          Get.to(() => MessageVideoPlayerView(
                e: widget.message?.data ?? '',
                videoFile: videoFile ?? Uint8List(0),
              ));
        },
        child: Container(
          width: Get.width * .6,
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0 * 0.75, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isReply
                ? Colors.transparent
                : widget.message!.isSender
                    ? Colors.transparent
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  videoFile == null
                      ? const CupertinoActivityIndicator()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.memory(
                            videoFile!,
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(.5),
                    radius: 20,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30.r,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.videocam_rounded,
                            size: 16.r,
                            color: Colors.white,
                          ),
                          3.horizontalSpace,
                          Text(
                            convertSecondsToTime(videoPlayerController
                                    ?.value.duration.inSeconds ??
                                0),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                          3.horizontalSpace,
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.end,
                              DateFormat('hh:mm a dd MMM').format(
                                widget.message?.time.toLocal() ??
                                    DateTime.now(),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String convertSecondsToTime(int totalSeconds) {
  int minutes = totalSeconds ~/ 60; // Integer division for minutes
  int seconds = totalSeconds % 60; // Remainder gives the seconds
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
