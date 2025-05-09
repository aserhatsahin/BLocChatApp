part of 'send_message_bloc.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object?> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {}

class SendMessageFailure extends SendMessageState {
  final String error;

  const SendMessageFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
