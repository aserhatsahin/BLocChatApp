part of 'chat_list_bloc.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

final class ChatListLoadInitial extends ChatListState {}

final class ChatListLoading extends ChatListState {}

final class ChatListLoaded extends ChatListState {
  final List<ChatModel> chats;

  const ChatListLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

final class ChatListLoadFail extends ChatListState {}


