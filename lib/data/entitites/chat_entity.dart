import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final DateTime createdAt;
  final List<String> participantIds;
  final List<String> participantNames;
  final String lastMessage;
  final DateTime lastMessageTime;

  const ChatEntity({
    required this.chatId,
    required this.createdAt,
    required this.participantIds,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatEntity.fromDocument(Map<String, dynamic> doc) {
    return ChatEntity(
      chatId: doc['chatId'] as String? ?? '',
      createdAt: (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      participantIds: List<String>.from(doc['participantIds'] ?? []),
      participantNames: List<String>.from(doc['participantNames'] ?? []),
      lastMessage: doc['lastMessage'] as String? ?? '',
      lastMessageTime: (doc['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'chatId': chatId,
      'createdAt': createdAt,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  @override
  List<Object?> get props => [
    chatId,
    createdAt,
    participantIds,
    participantNames,
    lastMessage,
    lastMessageTime,
  ];

  @override
  String toString() {
    return 'ChatEntity(chatId: $chatId, createdAt: $createdAt, participantIds: $participantIds, participantNames: $participantNames, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime)';
  }
}
