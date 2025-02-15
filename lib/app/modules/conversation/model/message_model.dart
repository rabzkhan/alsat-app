enum ChatMessageType { text, image, map, audio, video, post }

enum MessageStatus { notSent, notView, viewed }

class ChatMessage {
  final String id;
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final bool isShowMessageTime;
  final DateTime time;
  final ChatUser otherUser;
  final dynamic data;
  final ChatMessage? replyMessage;

  ChatMessage({
    this.text = '',
    required this.id,
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.time,
    required this.otherUser,
    required this.data,
    this.replyMessage,
    this.isShowMessageTime = false,
  });
}

class ChatUser {
  final String name;
  final String imageUrl;
  final String id;
  ChatUser({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
