import 'dart:developer';
import 'dart:io';

import 'package:alsat/app/components/product_list_tile.dart';
import 'package:alsat/app/modules/authentication/controller/auth_controller.dart';
import 'package:alsat/app/modules/product/controller/product_controller.dart';
import 'package:alsat/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';

import '../../../components/network_image_preview.dart';
import '../controller/conversation_controller.dart';
import '../model/conversation_messages_res.dart';
import '../model/conversations_res.dart';

class ConversationView extends StatefulWidget {
  final ConversationModel conversation;
  const ConversationView({super.key, required this.conversation});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final List<types.Message> _messages = [];
  late types.User _user;

  final ConversationController conversationController = Get.find();
  AuthController authController = Get.find();
  @override
  void initState() {
    super.initState();

    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60.h,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_sharp,
              size: 30.r,
              color: bold.color!.withOpacity(.5),
            ),
          )
        ],
        title: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: NewworkImagePreview(
                  radius: 30.r,
                  url: conversationController.selectConversation.value
                          ?.participants?.firstOrNull?.picture ??
                      "",
                  height: 44.h,
                ),
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${conversationController.selectConversation.value?.participants?.lastOrNull?.userName}',
                    style: bold.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),
                  1.verticalSpace,
                  Text(
                    'Active Now',
                    style: regular.copyWith(
                      fontSize: 11.sp,
                    ),
                  )
                ],
              )
            ],
          );
        }),
      ),
      body: Obx(() {
        return conversationController.isConversationMessageLoading.value
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Chat(
                emojiPicker: () {},
                productWiget: const Center(),
                theme: DefaultChatTheme(
                  messageBorderRadius: 12.r,
                  messageInsetsVertical: 8.h,
                  sentMessageBodyTextStyle: regular.copyWith(
                    color: Colors.white,
                  ),
                  secondaryColor: Colors.white,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  primaryColor: context.theme.primaryColor,
                  inputBackgroundColor:
                      context.theme.appBarTheme.backgroundColor!,
                  inputTextColor: context.theme.textTheme.bodyLarge!.color!,
                  inputElevation: 1,
                  inputBorderRadius: BorderRadius.circular(20.r),
                  inputMargin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ).copyWith(
                    top: 6.h,
                  ),
                ),
                messages: conversationController.coverMessage.value,
                onAttachmentPressed: _handleAttachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: _user,
              );
      }),
    );
  }

  void _handleAttachmentPressed() {
    ProductController productController = Get.find();
    productController.pickImage(context, external: true).then((value) async {
      if (value != null) {
        final bytes = await value.first.readAsBytes();
        final image = await decodeImageFromList(bytes);

        final message = types.ImageMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: value.first.path,
          size: bytes.length,
          uri: value.first.path,
          width: image.width.toDouble(),
        );

        _addMessage(message);
      }
    });
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = Dio();
          final request = await client.get((message.uri));
          final bytes = request.data;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  Map<String, dynamic>? imageMap;
  Future<void> _addMessage(types.Message message) async {
    // _messages.insert(0, message);
    imageMap = null;
    conversationController.coverMessage.insert(0, message);
    if (message.type == MessageType.image) {
      imageMap = {
        "type": "image",
        "post": null,
        "file": await imageToBase64(message.toJson()['uri'])
      };
    }
    conversationController.sendMessages(message.toJson()['text'] ?? '',
        map: imageMap);
  }

  void _loadMessages() async {
    AuthController authController = Get.find();
    String userID = authController.userDataModel.value.id ?? "";
    Participant? user = widget.conversation.participants
        ?.firstWhereOrNull((e) => e.id == userID);
    _user = types.User(
      firstName: authController.userDataModel.value.userName,
      imageUrl: authController.userDataModel.value.picture,
      id: authController.userDataModel.value.id ?? '',
    );
    conversationController.selectConversation.value = widget.conversation;
    conversationController.getConversationsMessages();
  }
}
