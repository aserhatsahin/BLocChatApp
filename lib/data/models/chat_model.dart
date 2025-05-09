import 'package:bloc_chatapp/data/entitites/chat_entity.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String chatId;
  final DateTime createdAt;
  final List<String> participantIds;
  final List<String> participantNames;
  final String lastMessage;
  final String lastMessageSenderId; // Yeni alan
  final DateTime lastMessageTime;

  const ChatModel({
    required this.chatId,
    required this.createdAt,
    required this.participantIds,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
  });

  ChatEntity toEntity() {
    return ChatEntity(
      chatId: chatId,
      createdAt: createdAt,
      participantIds: participantIds,
      participantNames: participantNames,
      lastMessage: lastMessage,
      lastMessageSenderId: lastMessageSenderId, // Yeni alan
      lastMessageTime: lastMessageTime,
    );
  }

  bool get isEmpty => this == ChatModel.empty;
  bool get isNotEmpty => this != ChatModel.empty;

  ChatModel copyWith({
    String? chatId,
    DateTime? createdAt,
    List<String>? participantIds,
    List<String>? participantNames,
    String? lastMessage,
    String? lastMessageSenderId, // Yeni alan
    DateTime? lastMessageTime,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId, // Yeni alan
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  static var empty = ChatModel(
    chatId: '',
    createdAt: DateTime.now(),
    participantIds: [],
    participantNames: [],
    lastMessage: '',
    lastMessageSenderId: '', // Yeni alan
    lastMessageTime: DateTime.now(),
  );

  static ChatModel fromEntity(ChatEntity entity) {
    return ChatModel(
      chatId: entity.chatId,
      createdAt: entity.createdAt,
      participantIds: entity.participantIds,
      participantNames: entity.participantNames,
      lastMessage: entity.lastMessage,
      lastMessageSenderId: entity.lastMessageSenderId, // Yeni alan
      lastMessageTime: entity.lastMessageTime,
    );
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
}
