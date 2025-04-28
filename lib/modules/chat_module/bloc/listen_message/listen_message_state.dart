part of 'listen_message_bloc.dart';

sealed class ListenMessageState extends Equatable {
  const ListenMessageState();

  @override
  List<Object?> get props => [];
}

final class ListenMessageInitial extends ListenMessageState {}

final class ListenMessageLoading extends ListenMessageState {}

final class ListenMessageSuccess extends ListenMessageState {
  final List<MessageModel> messages;

  const ListenMessageSuccess({required this.messages});

  @override
  List<Object?> get props => [messages];
}

final class ListenMessageFailure extends ListenMessageState {
  final String error;

  const ListenMessageFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
