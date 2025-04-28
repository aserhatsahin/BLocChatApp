import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/entitites/message_entity.dart';
import 'package:bloc_chatapp/data/models/message_model.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'listen_message_state.dart';

class ListenMessageBloc extends Bloc<ListenMessageEvent, ListenMessageState> {
  final ChatRepository chatRepository;

  ListenMessageBloc({required this.chatRepository}) : super(ListenMessageInitial()) {
    on<ListenMessagesRequested>((event, emit) async {
      emit(ListenMessageLoading());
      await emit.forEach(
        chatRepository.getChatData(event.chatId),
        onData: (QuerySnapshot snapshot) {
          final messages =
              snapshot.docs
                  .map(
                    (doc) => MessageModel.fromEntity(
                      MessageEntity.fromDocument(doc.data() as Map<String, dynamic>),
                    ),
                  )
                  .toList();
          log("Messages: $messages"); // Debug için
          return ListenMessageSuccess(messages: messages);
        },
        onError: (error, stackTrace) {
          log("Error: $error"); // Debug için
          return ListenMessageFailure(error: 'Mesajlar yüklenemedi: $error');
        },
      );
    });
  }
}
