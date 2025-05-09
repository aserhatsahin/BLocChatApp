import 'package:equatable/equatable.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageRequested extends SendMessageEvent {
  final String receiverUid;
  final String message;

  const SendMessageRequested({required this.receiverUid, required this.message});

  @override
  List<Object?> get props => [receiverUid, message];
}
