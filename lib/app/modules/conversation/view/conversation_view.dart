import 'package:alsat/app/components/product_list_tile.dart';
import 'package:alsat/app/modules/conversation/data.dart';
import 'package:alsat/app/modules/conversation/models/theme.dart';
import 'package:alsat/config/theme/app_colors.dart';
import 'package:alsat/config/theme/app_text_theme.dart';
import 'package:chatview/chatview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/custom_appbar.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({super.key});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  final _chatController = ChatController(
    initialMessageList: Data.messageList,
    scrollController: ScrollController(),
    currentUser: ChatUser(
      id: '1',
      name: 'Flutter',
      profilePhoto: Data.profileImage,
    ),
    otherUsers: [
      ChatUser(
        id: '2',
        name: 'Simform',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '3',
        name: 'Jhon',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '4',
        name: 'Mike',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '5',
        name: 'Rich',
        profilePhoto: Data.profileImage,
      ),
    ],
  );

  void _showHideTypingIndicator() {
    _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
  }

  void receiveMessage() async {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        message: 'I will schedule the meeting.',
        createdAt: DateTime.now(),
        sentBy: '2',
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    _chatController.addReplySuggestions([
      const SuggestionItemData(text: 'Thanks.'),
      const SuggestionItemData(text: 'Thank you very much.'),
      const SuggestionItemData(text: 'Great.')
    ]);
  }

  @override
  void initState() {
    _showHideTypingIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: const SafeArea(child: CustomAppBar())),
      body: ChatView(
        productWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: const ProductListTile(),
        ),
        chatController: _chatController,
        onSendTap: _onSendTap,
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
          enableScrollToBottomButton: true,
        ),
        scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
          backgroundColor: Get.theme.primaryColor,
          border: Border.all(
            color: isDarkTheme ? Colors.transparent : Colors.grey,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            weight: 10,
            size: 30,
          ),
        ),
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: const ChatViewStateWidgetConfiguration(),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: Colors.white,
          flashingCircleDarkColor: Get.theme.primaryColor,
        ),
        appBar: ChatViewAppBar(
          elevation: 0,
          backGroundColor: Theme.of(context).scaffoldBackgroundColor,
          profilePicture: Data.profileImage,
          chatTitle: "John Coltrane",
          chatTitleTextStyle: bold,
          userStatus: "active now",
          userStatusTextStyle: regular.copyWith(
            color: Get.theme.shadowColor.withOpacity(.2),
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_sharp))
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: Get.theme.primaryColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: Get.theme.primaryColor.withOpacity(.2),
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: const ImagePickerIconsConfiguration(),
          replyMessageColor: AppColors.liteGray,
          // defaultSendButtonColor: theme.sendButtonColor,
          // replyDialogColor: theme.replyDialogColor,
          // replyTitleColor: theme.replyTitleColor,
          // textFieldBackgroundColor: theme.textFieldBackgroundColor,
          // closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.sp,
            ),
            // onMessageTyping: (status) {
            //   /// Do with status
            //   debugPrint(status.toString());
            // },
            compositionThresholdTime: const Duration(seconds: 1),
            // textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          // micIconColor: theme.replyMicIconColor,
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
            ),
            linkPreviewConfig: const LinkPreviewConfiguration(),
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
            color: Colors.white,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                // color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              bodyStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              titleStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              backgroundColor: Colors.transparent,
            ),
            // textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              debugPrint('Message Read');
            },
            // senderNameTextStyle:
            //     TextStyle(color: theme.inComingChatBubbleTextColor),
            color: Colors.black.withOpacity(.4),
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: Colors.black.withOpacity(.4),
          // backgroundColor: theme.replyPopupColor,
          // buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          // topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: Colors.black.withOpacity(.4),
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: Get.theme.primaryColor,
            // borderColor: theme.messageReactionBackGroundColor,
            reactedUserCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: AppColors.liteGray,
              reactedUserTextStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: Get.theme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: theme.shareIconBackgroundColor,
              defaultIconColor: theme.shareIconColor,
            ),
          ),
        ),
        profileCircleConfig: const ProfileCircleConfiguration(
          profileImageUrl: Data.profileImage,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: Colors.black.withOpacity(.4),
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: const RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.white,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
        replySuggestionsConfig: ReplySuggestionsConfig(
          itemConfig: SuggestionItemConfig(
            decoration: BoxDecoration(
              color: theme.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.outgoingChatBubbleColor ?? Colors.white,
              ),
            ),
            textStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          onTap: (item) =>
              _onSendTap(item.text, const ReplyMessage(), MessageType.text),
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        createdAt: DateTime.now(),
        message: message,
        sentBy: _chatController.currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}
