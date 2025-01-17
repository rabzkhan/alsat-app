import 'dart:async';
import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:alsat/app/modules/conversation/controller/message_controller.dart';
import 'package:alsat/app/modules/conversation/widget/video_message_tile.dart';
import 'package:alsat/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../product/controller/product_controller.dart';
import 'package:record/record.dart';
import '../controller/conversation_controller.dart';
import '../view/map_address_picker_view.dart';

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
    Directory? appDirectory = await getExternalStorageDirectory();
    audioFilePath =
        '${appDirectory?.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
    if (!await appDirectory!.exists()) {
      await appDirectory.create(recursive: true);
    }
    try {
      bool isRecordingAvailable = await record.hasPermission();
      if (isRecordingAvailable) {
        String path = audioFilePath;
        await record.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
          ),
          path: path,
        );

        setState(() {
          isRecording = true;
          audioFilePath = path;
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _elapsedSeconds++;
          });
          _processAudioData(_elapsedSeconds);
        });
      }
    } catch (e) {}
  }

  // Stop recording
  Future<void> stopRecording() async {
    try {
      _elapsedSeconds = 0;
      await record.stop();
      _timer?.cancel();
      setState(() {
        isRecording = false;
      });
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  'Reply Message',
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
                                      padding: EdgeInsets.only(top: 10),
                                      child: CustomPaint(
                                        size: const Size(double.infinity, 50),
                                        painter: WaveformPainter(
                                          waveformData: _waveformData,
                                        ),
                                      ),
                                    ),
                                  ),
                                  7.horizontalSpace,
                                  InkWell(
                                    onTap: () {
                                      stopRecording();
                                      setState(() {
                                        isRecording = false;
                                      });
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
                                        GestureDetector(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              _emojiShowing = !_emojiShowing;
                                            });
                                          },
                                          child: Opacity(
                                            opacity: _emojiShowing ? .2 : 1,
                                            child: Image.asset(
                                              'assets/icons/emoji.png',
                                              height: 25.h,
                                              width: 25.w,
                                            ),
                                          ),
                                        ),
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
                                              hintText: "Type message",
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
                                          () => widget.conversationController
                                                  .typeMessageText.isNotEmpty
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
                            .isNotEmpty) {
                          widget.conversationController.sendMessage();
                        } else {
                          if (isRecording) {
                            stopRecording();

                            isRecording = false;
                            setState(() {});

                            widget.conversationController
                                .sendMessage(audioPath: audioFilePath);
                          } else {
                            startRecording();

                            isRecording = true;
                            setState(() {});
                          }
                        }
                      },
                      child: widget.conversationController.typeMessageText
                                  .isEmpty &&
                              !isRecording
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

  final List<double> _waveformData = [
    ...List.generate(40, (index) {
      return Random().nextDouble();
    })
  ];

  void _processAudioData(int duration) {
    double amplitude = Random().nextDouble();
    log.log('amplitude: $amplitude');
    _waveformData.add(amplitude);
    log.log('waveformData: ${_waveformData.length}');
    // setState(() {
    //   _waveformData.add(amplitude);
    // });
    if (_waveformData.length > 40) {
      _waveformData.removeAt(0);
    }
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  WaveformPainter({required this.waveformData});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    double xInterval = size.width / waveformData.length;
    double centerY = size.height / 2;

    for (int i = 0; i < waveformData.length; i++) {
      double x = i * xInterval;
      double y = centerY - (waveformData[i] * size.height / 2);
      canvas.drawLine(Offset(x, centerY), Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
