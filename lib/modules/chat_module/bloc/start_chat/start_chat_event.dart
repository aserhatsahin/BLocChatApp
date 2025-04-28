import 'package:equatable/equatable.dart';

abstract class StartChatEvent extends Equatable {
  const StartChatEvent();

  @override
  List<Object?> get props => [];
}

class StartChatRequested extends StartChatEvent {
  final String receiverUid;
  final String senderUid;

  const StartChatRequested({required this.receiverUid, required this.senderUid});

  @override
  List<Object?> get props => [receiverUid];
}
