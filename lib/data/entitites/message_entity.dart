import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String message;
  final String messageId;
  final String senderId;
  final String receiverId;
  final DateTime sendedAt;

  const MessageEntity({
    required this.message,
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.sendedAt,
  });

  static MessageEntity fromDocument(Map<String, dynamic> doc) {
    return MessageEntity(
      message: doc["message"] as String? ?? '',
      messageId: doc["messageId"] as String? ?? '',
      sendedAt: (doc['sendedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderId: doc["senderId"] as String? ?? '',
      receiverId: doc["receiverId"] as String? ?? '',
    );
  }

  Map<String, Object> toDocument() {
    return {
      'message': message,
      'messageId': messageId,
      'sendedAt': Timestamp.fromDate(sendedAt),
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  @override
  List<Object?> get props => [message, messageId, sendedAt, senderId, receiverId];

  @override
  String toString() {
    return 'MessageEntity(message: $message, messageId: $messageId, sendedAt: $sendedAt, senderId: $senderId, receiverId: $receiverId)';
  }
}
