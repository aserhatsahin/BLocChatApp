part of 'send_message_bloc.dart';



sealed class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object?> get props => [];
}

final class SendMessageInitial extends SendMessageState {}

final class SendMessageLoading extends SendMessageState {}

final class SendMessageSuccess extends SendMessageState {
  final String message;
  final String receiverUID;

  const SendMessageSuccess(this.message, this.receiverUID);

  @override
  List<Object?> get props => [message, receiverUID];
}

final class SendMessageFailure extends SendMessageState {
  final String error;

  const SendMessageFailure({required this.error});

  @override
  List<Object?> get props => [error];
}