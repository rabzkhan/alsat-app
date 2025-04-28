import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:get/get.dart';

import '../auth_user_tab/widgets/story_isolate.dart';

class ThumbnailService extends GetxController {
  final thumbnails = <String, Uint8List?>{}.obs;

  Future<void> loadThumbnail(String videoPath) async {
    if (thumbnails.containsKey(videoPath)) return; // already loaded

    final receivePort = ReceivePort();

    await FlutterIsolate.spawn(
      isolateEntry,
      {
        'videoPath': videoPath,
        'sendPort': receivePort.sendPort,
      },
    );

    final thumbnail = await receivePort.first as Uint8List?;
    thumbnails[videoPath] = thumbnail;
  }
}
