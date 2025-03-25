

import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime sendedAt;

  const MessageEntity({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.sendedAt,
  });

  static MessageEntity fromDocument(Map<String, dynamic> doc) {
    return MessageEntity(
      message: doc["message"] as String,
      sendedAt: doc["sendeAt"],
      senderId: doc["senderId"] as String,
      receiverId: doc["receiverId"] as String,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'message': message,
      'sendedAt': sendedAt,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [message, sendedAt, senderId, receiverId];

  @override
  String toString() {
    return 'MessageEntity(message: $message, sendedAt: $sendedAt, senderId: $senderId, receiverId: $receiverId)';
  }
}
