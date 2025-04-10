part of 'start_chat_bloc.dart';

sealed class StartChatEvent extends Equatable {
  const StartChatEvent();

  @override
  List<Object> get props => [];
}

class StartChatRequested extends StartChatEvent {
  const StartChatRequested({required this.receiverUid});
  final String receiverUid;
}
