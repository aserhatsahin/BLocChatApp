part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

//load chats
class LoadChatsRequested extends ChatListEvent {
  const LoadChatsRequested({required this.uid});
  final String uid;
}

