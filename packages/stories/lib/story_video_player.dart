import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class StoryVideoPlayer extends StatefulWidget {
  final String url;
  const StoryVideoPlayer({super.key, required this.url});

  @override
  State<StoryVideoPlayer> createState() => _StoryVideoPlayerState();
}

class _StoryVideoPlayerState extends State<StoryVideoPlayer> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      placeholder: Container(
        color: Colors.white,
      ),
      widget.url,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 1000 * 1024 * 1024,
        maxCacheFileSize: 100 * 1024 * 1024,
        preCacheSize: 100 * 1024 * 1024,
      ),
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        aspectRatio: 9 / 16,
        placeholder: Center(),
        showPlaceholderUntilPlay: true,
        autoDetectFullscreenAspectRatio: true,
        autoDetectFullscreenDeviceOrientation: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: false,
          enableSkips: false,
          enableMute: false,
          enableProgressBar: false,
          enableSubtitles: false,
          enableAudioTracks: false,
          enablePlaybackSpeed: false,
          enablePip: false,
          enableRetry: false,
          enableOverflowMenu: false,
          enableQualities: false,
          showControlsOnInitialize: false,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
}
