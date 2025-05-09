import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final DateTime createdAt;
  final List<String> participantIds;
  final List<String> participantNames;
  final String lastMessage;
  final String lastMessageSenderId; // Yeni alan
  final DateTime lastMessageTime;

  const ChatEntity({
    required this.chatId,
    required this.createdAt,
    required this.participantIds,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
  });

  factory ChatEntity.fromDocument(Map<String, dynamic> doc) {
    return ChatEntity(
      chatId: doc['chatId'] as String? ?? '',
      createdAt: (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      participantIds: List<String>.from(doc['participantIds'] ?? []),
      participantNames: List<String>.from(doc['participantNames'] ?? []),
      lastMessage: doc['lastMessage'] as String? ?? '',
      lastMessageSenderId: doc['lastMessageSenderId'] as String? ?? '', // Yeni alan
      lastMessageTime: (doc['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'chatId': chatId,
      'createdAt': Timestamp.fromDate(createdAt),
      'participantIds': participantIds,
      'participantNames': participantNames,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId, // Yeni alan
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }

  @override
  List<Object?> get props => [
    chatId,
    createdAt,
    participantIds,
    participantNames,
    lastMessage,
    lastMessageSenderId,
    lastMessageTime,
  ];

  @override
  String toString() {
    return 'ChatEntity(chatId: $chatId, createdAt: $createdAt, participantIds: $participantIds, participantNames: $participantNames, lastMessage: $lastMessage, lastMessageSenderId: $lastMessageSenderId, lastMessageTime: $lastMessageTime)';
  }
}
