
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class MessageVideoPlayerView extends StatefulWidget {
  final String e;
  final Uint8List videoFile;
  const MessageVideoPlayerView(
      {super.key, required this.e, required this.videoFile});

  @override
  State<MessageVideoPlayerView> createState() => _MessageVideoPlayerViewState();
}

class _MessageVideoPlayerViewState extends State<MessageVideoPlayerView> {
  late VideoPlayerController videoPlayerController;
  bool isVideoPrepared = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    if (videoPlayerController.value.isInitialized) {
      videoPlayerController.dispose();
    }
    super.dispose();
  }

  init() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.e));
    await videoPlayerController.initialize();
    setState(() {
      isVideoPrepared = true;
    });
    videoPlayerController.addListener(() {
      setState(() {});
    });
    videoPlayerController.play();
    isPlaying = true;
  }

  void togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
      ),
      body: Hero(
        tag: widget.e,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox.expand(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video or Placeholder
                  if (!isVideoPrepared)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.r),
                      child: Image.memory(
                        widget.videoFile,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: togglePlayPause,
                      child: AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Video Progress Bar
                          VideoProgressIndicator(
                            videoPlayerController,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Colors.white,
                              bufferedColor: Colors.grey,
                              backgroundColor: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Time Display (Current Time / Total Duration)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDuration(
                                    videoPlayerController.value.position),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                formatDuration(
                                    videoPlayerController.value.duration),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  // // Play/Pause Button
                  if (!isPlaying && isVideoPrepared)
                    IconButton(
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: togglePlayPause,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
