

import 'package:bloc_chatapp/data/entitites/message_entity.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {

  final String message;
  final String messageId;
  final String senderId;
  final String receiverId;
  final DateTime sendedAt;
  final bool isEdited;
  const MessageModel({
    required this.message,
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.sendedAt,
    required this.isEdited,
  });

  @override
  List<Object?> get props => [message, messageId, senderId, receiverId, sendedAt, isEdited];

  MessageEntity toEntity() {
    return MessageEntity(
      message: message,
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
      sendedAt: sendedAt,
      isEdited: isEdited,
    );
  }

  // getter to determine whether the current Chat is empty
  bool get isEmpty => this == MessageModel.empty;
  //getter to determine whether the current Chat is not empty
  bool get isNotEmpty => this != MessageModel.empty;

  MessageModel copyWith({
    String? message,
    String? messageId,
    String? senderId,
    String? receiverId,
    DateTime? sendedAt,
    bool? isEdited,
  }) {
    return MessageModel(
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sendedAt: sendedAt ?? this.sendedAt,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  static var empty = MessageModel(
    message: '',
    messageId: '',
    senderId: '',
    receiverId: '',
    sendedAt: DateTime.now(),
    isEdited: false,
  );
  static MessageModel fromEntity(MessageEntity entity) {
    return MessageModel(
      message: entity.message,
      messageId: entity.messageId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      sendedAt: entity.sendedAt,
      isEdited: entity.isEdited,
    );
  }

  get chat => MessageModel(
    message: message,
    messageId: messageId,
    senderId: senderId,
    receiverId: receiverId,
    sendedAt: sendedAt,
    isEdited: isEdited,
  );
}
