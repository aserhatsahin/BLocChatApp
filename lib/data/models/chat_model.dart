import 'package:bloc_chatapp/data/entitites/chat_entity.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String chatId;
  final DateTime createdAt;
  final List<String> participants;

  const ChatModel({required this.chatId, required this.createdAt, required this.participants});

  ChatEntity toEntity() {
    return ChatEntity(chatId: chatId, createdAt: createdAt, participants: participants);
  }

  bool get isEmpty => this == ChatModel.empty;
  bool get isNotEmpty => this != ChatModel.empty;

  ChatModel copyWith({String? chatId, DateTime? createdAt, List<String>? participants}) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      participants: participants ?? this.participants,
    );
  }

  static var empty = ChatModel(chatId: '', createdAt: DateTime.now(), participants: []);

  static ChatModel fromEntity(ChatEntity entity) {
    return ChatModel(
      chatId: entity.chatId,
      createdAt: entity.createdAt,
      participants: entity.participants,
    );
  }

  @override
  List<Object?> get props => [chatId, createdAt, participants];
}
