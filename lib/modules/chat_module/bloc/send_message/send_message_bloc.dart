import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/send_message/send_message_event.dart';
import 'package:equatable/equatable.dart';

part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatRepository _chatRepository;

  SendMessageBloc(ChatRepository chatRepository)
    : _chatRepository = chatRepository,
      super(SendMessageInitial()) {
    on<SendMessageRequested>((event, emit) async {
      emit(SendMessageLoading());
      try {
        await _chatRepository.sendMessage(event.receiverUID, event.message);
        log("Message sent: ${event.message}"); // Debug için
        emit(SendMessageSuccess(event.message, event.receiverUID));
      } catch (e) {
        log("Error sending message: $e"); // Debug için
        emit(SendMessageFailure(error: 'Mesaj gönderilemedi: $e'));
      }
    });
  }
}
