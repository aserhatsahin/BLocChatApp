

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/models/chat_model.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _chatRepository;
  ChatListBloc(ChatRepository chatRepository)
    : _chatRepository = chatRepository,
      super(ChatListLoadInitial()) {
    on<LoadChatsRequested>((event, emit) async {
      try {
        emit(ChatListLoading());

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await emit.forEach<List<ChatModel>>(// listen to the chat list stream continuously
            _chatRepository.getUserChats(event.uid),
            onData: (chats) {
              return ChatListLoaded(chats: chats);// if new data comes send this state and emit it
            },
            onError: (_, __) => ChatListLoadFail(),
          );
        } else {
          emit(ChatListLoadFail());
        }
      } catch (e) {
        emit(ChatListLoadFail());
      }
    });
  }
}
