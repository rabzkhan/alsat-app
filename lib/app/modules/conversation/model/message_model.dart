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
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      messageType: ChatMessageType.values[json['messageType']],
      messageStatus: MessageStatus.values[json['messageStatus']],
      isSender: json['isSender'],
      isShowMessageTime: json['isShowMessageTime'] ?? false,
      time: DateTime.parse(json['time']),
      otherUser: ChatUser.fromJson(json['otherUser']),
      data: json['data'],
      replyMessage: json['replyMessage'] != null
          ? ChatMessage.fromJson(json['replyMessage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'messageType': messageType.index,
      'messageStatus': messageStatus.index,
      'isSender': isSender,
      'isShowMessageTime': isShowMessageTime,
      'time': time.toIso8601String(),
      'otherUser': otherUser.toJson(),
      'data': data,
      'replyMessage': replyMessage?.toJson(),
    };
  }
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
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
