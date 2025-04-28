part of 'start_chat_bloc.dart';

sealed class StartChatState extends Equatable {
  const StartChatState();

  @override
  List<Object?> get props => [];
}

final class StartChatInitial extends StartChatState {}

final class StartChatLoading extends StartChatState {}

final class StartChatSuccess extends StartChatState {
  final String chatId;

  const StartChatSuccess({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

final class StartChatFailure extends StartChatState {
  final String error;

  const StartChatFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
