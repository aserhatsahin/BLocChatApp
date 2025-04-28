import 'package:equatable/equatable.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageRequested extends SendMessageEvent {
  final String message;
  final String receiverUID;

  const SendMessageRequested({required this.message, required this.receiverUID});

  @override
  List<Object> get props => [message, receiverUID];
}
