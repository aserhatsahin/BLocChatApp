import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final DateTime createdAt;
  final List<String> participants;

  const ChatEntity({required this.chatId, required this.createdAt, required this.participants});

  static ChatEntity fromDocument(Map<String, dynamic> doc) {
    return ChatEntity(
      chatId: doc["chatId"] as String,
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      participants: List<String>.from(doc["participants"] ?? []),
    );
  }

  Map<String, Object> toDocument() {
    return {'chatId': chatId, 'createdAt': createdAt, 'participants': participants};
  }

  @override
  List<Object?> get props => [chatId, createdAt, participants];

  @override
  String toString() {
    return 'ChatEntity\nchatId: $chatId, createdAt: $createdAt, participants: $participants';
  }
}
