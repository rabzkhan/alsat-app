import 'package:alsat/app/modules/conversation/controller/message_controller.dart';
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
import '../../product/controller/product_controller.dart';

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
  final RecorderController recorderController = RecorderController();
  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    recorderController.onCurrentDuration.listen((duration) {
      widget.conversationController.recordTime.value = duration;
    });
    super.initState();
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
                            child: Row(
                              children: [
                                15.horizontalSpace,
                                Obx(() {
                                  return Text(
                                    "${widget.conversationController.recordTime.value?.inSeconds ?? 0} s",
                                    style: regular.copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  );
                                }),
                                Expanded(
                                  child: AudioWaveforms(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: Colors.white,
                                    ),
                                    waveStyle: const WaveStyle(
                                        showHourInDuration: true,
                                        waveColor: AppColors.primary,
                                        labelSpacing: 0,
                                        extendWaveform: true,
                                        showMiddleLine: false,
                                        scaleFactor: 100),
                                    // backgroundColor: Colors.white,
                                    recorderController: recorderController,
                                    size: const Size.fromHeight(55),
                                    margin: EdgeInsets.zero,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ).copyWith(right: 0),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    recorderController.stop();
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
                          if (recorderController.hasPermission) {
                            if (isRecording) {
                              recordedFilePath =
                                  await recorderController.stop();
                              isRecording = false;
                              setState(() {});

                              widget.conversationController
                                  .sendMessage(audioPath: recordedFilePath);
                            } else {
                              recorderController.record();
                              isRecording = true;
                              setState(() {});
                            }
                          } else {
                            recorderController.checkPermission();
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
}
