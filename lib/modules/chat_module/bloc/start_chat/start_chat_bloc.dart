import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/start_chat/start_chat_event.dart';
import 'package:equatable/equatable.dart';


part 'start_chat_state.dart';

class StartChatBloc extends Bloc<StartChatEvent, StartChatState> {
  final ChatRepository _chatRepository;

  StartChatBloc(ChatRepository chatRepository)
    : _chatRepository = chatRepository,
      super(StartChatInitial()) {
    on<StartChatRequested>((event, emit) async {
      emit(StartChatLoading());
      try {
        final chatId = "${event.senderUid}-${event.receiverUid}";
        await _chatRepository.createChatIfNotExist(event.receiverUid);
        log("Chat started: $chatId"); // Debug için
        emit(StartChatSuccess(chatId: chatId));
      } catch (e) {
        log("Error starting chat: $e"); // Debug için
        emit(StartChatFailure(error: 'Sohbet başlatılamadı: $e'));
      }
    });
  }
}
