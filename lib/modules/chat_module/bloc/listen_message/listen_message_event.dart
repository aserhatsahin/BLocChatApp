import 'package:equatable/equatable.dart';

abstract class ListenMessageEvent extends Equatable {
  const ListenMessageEvent();

  @override
  List<Object?> get props => [];
}

class ListenMessagesRequested extends ListenMessageEvent {
  final String chatId;

  const ListenMessagesRequested({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}
