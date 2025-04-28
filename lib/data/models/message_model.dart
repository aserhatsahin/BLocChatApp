

import 'package:bloc_chatapp/data/entitites/message_entity.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {

  final String message;
final String messageId;
  final String senderId;


  final String receiverId;
  final DateTime sendedAt;
  const MessageModel({
    required this.message,
required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.sendedAt,
  });

  @override
  List<Object?> get props => [message, messageId,senderId, receiverId, sendedAt];

  MessageEntity toEntity() {
    return MessageEntity(
      message: message,
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
      sendedAt: sendedAt,
    );
  }

  // getter to determine whether the current Chat is empty
  bool get isEmpty => this == MessageModel.empty;
  //getter to determine whether the current Chat is not empty
  bool get isNotEmpty => this != MessageModel.empty;

  MessageModel copyWith({
    required String message,
    required String messageId,
    required String senderId,
    required String receiverId,
    required DateTime sendedAt,
  }) {
    return MessageModel(
      message: message,
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
      sendedAt: sendedAt,
    );
  }

  static var empty = MessageModel(
    message: '',
    messageId: '',
    senderId: '',
    receiverId: '',
    sendedAt: DateTime.now(),
  );
  static MessageModel fromEntity(MessageEntity entity) {
    return MessageModel(
      message: entity.message,
      messageId: entity.messageId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      sendedAt: entity.sendedAt,
    );
  }

  get chat => MessageModel(
    message: message,
    messageId: messageId,
    senderId: senderId,
    receiverId: receiverId,
    sendedAt: sendedAt,
  );
}
