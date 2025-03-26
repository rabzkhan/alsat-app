import 'dart:async';
import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:alsat/app/modules/conversation/controller/message_controller.dart';
import 'package:alsat/app/modules/conversation/widget/music_ui.dart';
import 'package:alsat/app/modules/conversation/widget/video_message_tile.dart';
import 'package:alsat/utils/helper.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../product/controller/product_controller.dart';
import 'package:record/record.dart';
import '../controller/conversation_controller.dart';
import '../view/map_address_picker_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInputField extends StatefulWidget {
  final ConversationController conversationController;
  final MessageController messageController;
  const ChatInputField(
      {super.key,
      required this.conversationController,
      required this.messageController});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _scrollController = ScrollController();

  bool _emojiShowing = false;
  String? recordedFilePath;
  bool isRecording = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  final record = AudioRecorder();

  String audioFilePath = "";
  Future<void> startRecording() async {
    try {
      if (isRecording) {
        await stopRecording();
      }

      Directory appDirectory = await getApplicationDocumentsDirectory();
      String filePath =
          '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      if (!await appDirectory.exists()) {
        await appDirectory.create(recursive: true);
      }

      bool isRecordingAvailable = await record.hasPermission();
      if (isRecordingAvailable) {
        await record.start(
          const RecordConfig(
            encoder: AudioEncoder.opus, // 🔹 Use Opus instead of AAC
            bitRate: 16000, // 🔹 Reduce bit rate for smaller file size
            sampleRate: 12000, // 🔹 Lower sample rate to save space
            numChannels: 1, // 🔹 Use mono for efficient storage
          ),
          path: filePath,
        );

        setState(() {
          isRecording = true;
          audioFilePath = filePath;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _elapsedSeconds++;
          });
        });
      }
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  // Stop recording
  Future<void> stopRecording() async {
    try {
      await record.stop();
      _elapsedSeconds = 0;
      _timer?.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isRecording = false;
        });
      });
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  // Future<Map<String, dynamic>> audioToBase64(String inputFilePath) async {
  //   Logger().d("Processing file: ${inputFilePath.toString()}");

  //   try {
  //     String outputFilePath = '${inputFilePath}_compressed.opus';

  //     // 🔹 Delete existing compressed file if present
  //     final File existingFile = File(outputFilePath);
  //     if (await existingFile.exists()) {
  //       await existingFile.delete();
  //     }

  //     // 🔥 Ultra Compression (6kbps bitrate, 3200Hz sample rate, mono audio)
  //     final session = await FFmpegKit.execute(
  //         '-i "$inputFilePath" -c:a libopus -b:a 6k -ar 3200 -ac 1 "$outputFilePath"');

  //     final returnCode = await session.getReturnCode();
  //     if (returnCode == null || !ReturnCode.isSuccess(returnCode)) {
  //       Logger().d('❌ FFmpeg Compression Failed! Code: $returnCode');
  //       return {};
  //     }

  //     // 🔹 Wait until the file is fully written
  //     int retries = 0;
  //     while (!await existingFile.exists() || await existingFile.length() == 0) {
  //       if (retries > 10) {
  //         Logger().d(
  //             '❌ Error: Compressed file not found or empty after multiple retries.');
  //         return {};
  //       }
  //       await Future.delayed(
  //           const Duration(milliseconds: 300)); // 🔹 Dynamic wait time
  //       retries++;
  //     }

  //     // ✅ Read file bytes
  //     final List<int> audioBytes = await existingFile.readAsBytes();
  //     final int fileSize = audioBytes.length;
  //     final String hash = sha256.convert(audioBytes).toString();
  //     final String base64Audio =
  //         "data:audio/opus;base64,${base64Encode(audioBytes)}";

  //     // 🔥 Delete compressed file after encoding to save space
  //     await existingFile.delete();

  //     Logger().d('✅ Audio compression successful! Final size: $fileSize bytes');

  //     return {
  //       "name": existingFile.uri.pathSegments.last,
  //       "type": "audio",
  //       "size": fileSize,
  //       "hash": hash,
  //       "content_type": "audio/opus",
  //       "base64": base64Audio,
  //     };
  //   } catch (e) {
  //     Logger().d('❌ Error during compression and encoding: $e');
  //     return {};
  //   }
  // }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(Get.context!)!;

    return Obx(() {
      return Container(
        margin: EdgeInsets.only(
          bottom: 10.h,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0 / 2,
        ),
        decoration: BoxDecoration(
          color: widget.messageController.selectReplyMessage.value == null
              ? Theme.of(context).scaffoldBackgroundColor
              : AppColors.primary.withOpacity(0.1),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //--reply message--//
              Obx(() {
                return widget.messageController.selectReplyMessage.value == null
                    ? const Center()
                    : Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localLanguage.reply_message,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                7.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        (widget
                                                        .messageController
                                                        .selectReplyMessage
                                                        .value
                                                        ?.text ??
                                                    '')
                                                .isEmpty
                                            ? '${widget.messageController.selectReplyMessage.value?.messageType.name.toUpperCase()}'
                                            : '${widget.messageController.selectReplyMessage.value?.text}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                widget.messageController.selectReplyMessage
                                    .value = null;
                              },
                              child: Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                          )
                        ],
                      );
              }),
              Row(
                children: [
                  isRecording
                      ? Expanded(
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  15.horizontalSpace,
                                  Text(
                                    "${convertSecondsToTime(_elapsedSeconds)} ",
                                    style: regular.copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  7.horizontalSpace,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12),
                                      child: MusicVisualizer(
                                        barCount: 30,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.purpleAccent,
                                          Colors.lightBlue,
                                        ],
                                        duration: Duration(milliseconds: 400),
                                        barWidth: 3,
                                        maxBarHeight: 50,
                                      ),
                                    ),
                                  ),
                                  7.horizontalSpace,
                                  InkWell(
                                    onTap: () {
                                      stopRecording();

                                      widget.conversationController.recordTime
                                          .value = Duration.zero;
                                    },
                                    child: CircleAvatar(
                                      radius: 11.r,
                                      backgroundColor: AppColors.primary,
                                      child: Icon(
                                        Icons.pause,
                                        size: 15.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  10.horizontalSpace,
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Obx(() {
                                          return widget
                                                      .messageController
                                                      .selectProductModel
                                                      .value ==
                                                  null
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    setState(() {
                                                      _emojiShowing =
                                                          !_emojiShowing;
                                                    });
                                                  },
                                                  child: Opacity(
                                                    opacity:
                                                        _emojiShowing ? .2 : 1,
                                                    child: Image.asset(
                                                      'assets/icons/emoji.png',
                                                      height: 25.h,
                                                      width: 25.w,
                                                    ),
                                                  ),
                                                )
                                              : Center();
                                        }),
                                        Expanded(
                                          child: TextFormField(
                                            onTap: () {
                                              setState(() {
                                                _emojiShowing = false;
                                              });
                                            },
                                            controller: widget
                                                .conversationController
                                                .messageController,
                                            onChanged: (value) {
                                              widget
                                                  .conversationController
                                                  .typeMessageText
                                                  .value = value;
                                            },
                                            style: context
                                                .theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  localLanguage.type_message,
                                              hintStyle: context
                                                  .theme.textTheme.bodyLarge,
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => widget
                                                      .conversationController
                                                      .typeMessageText
                                                      .isNotEmpty ||
                                                  widget
                                                          .messageController
                                                          .selectProductModel
                                                          .value !=
                                                      null
                                              ? const Center()
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        ProductController
                                                            productController =
                                                            Get.find();
                                                        productController
                                                            .pickImage(
                                                          context,
                                                          external: true,
                                                          both: true,
                                                        )
                                                            .then(
                                                          (value) async {
                                                            if (value != null) {
                                                              if (isImage(value
                                                                  .first)) {
                                                                widget
                                                                    .conversationController
                                                                    .sendMessage(
                                                                  image: value
                                                                      .first,
                                                                );
                                                              } else {
                                                                widget
                                                                    .conversationController
                                                                    .sendMessage(
                                                                  video: value
                                                                      .first,
                                                                );
                                                              }
                                                            }
                                                          },
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/attachment.png',
                                                        height: 25.h,
                                                        width: 25.w,
                                                      ),
                                                    ),
                                                    6.horizontalSpace,
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(
                                                            () =>
                                                                const LocationFromMapView(),
                                                            transition: Transition
                                                                .cupertinoDialog);
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/location.png',
                                                        height: 25.h,
                                                        width: 25.w,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  8.horizontalSpace,
                  Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        _emojiShowing = false;
                        if (widget.conversationController.typeMessageText
                                .isNotEmpty ||
                            widget.messageController.selectProductModel.value !=
                                null) {
                          if (widget
                                  .messageController.selectProductModel.value ==
                              null) {
                            widget.conversationController.sendMessage();
                          } else {
                            widget.conversationController.sendMessage(
                                product: widget
                                    .messageController.selectProductModel.value,
                                postId: widget.messageController
                                    .selectProductModel.value?.id
                                    .toString());
                            widget.messageController.selectProductModel.value =
                                null;
                          }
                        } else {
                          if (isRecording) {
                            stopRecording();
                            widget.conversationController.sendMessage(
                              audioPath: audioFilePath,
                            );
                          } else {
                            startRecording();
                            isRecording = true;
                            setState(() {});
                          }
                        }
                      },
                      child: widget.conversationController.typeMessageText
                                  .isEmpty &&
                              !isRecording &&
                              widget.messageController.selectProductModel
                                      .value ==
                                  null
                          ? CircleAvatar(
                              radius: 27,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.mic_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          : CircleAvatar(
                              radius: 27,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                    );
                  }),
                ],
              ),
              10.verticalSpace,
              Offstage(
                offstage: !_emojiShowing,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    widget.conversationController.typeMessageText.value = widget
                        .conversationController.messageController.text
                        .toString();
                  },
                  textEditingController:
                      widget.conversationController.messageController,
                  scrollController: _scrollController,
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    viewOrderConfig: const ViewOrderConfig(),
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      emojiSizeMax: 28 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.2
                              : 1.0),
                    ),
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                    ),
                    bottomActionBarConfig: const BottomActionBarConfig(
                      enabled: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
