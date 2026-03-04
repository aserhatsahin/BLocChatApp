import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'typing_indicator_event.dart';
part 'typing_indicator_state.dart';

class TypingIndicatorBloc
    extends Bloc<TypingIndicatorEvent, TypingIndicatorState> {
  final ChatRepository _chatRepository;

  TypingIndicatorBloc(ChatRepository chatRepository)
      : _chatRepository = chatRepository,
        super(const TypingIndicatorState(isTyping: false)) {
    on<SubscribeTypingIndicator>((event, emit) async {
      await emit.forEach<bool>(
        _chatRepository.listenTypingStatus(event.receiverUid),
        onData: (isTyping) {
          log('Typing status changed: $isTyping');
          return TypingIndicatorState(isTyping: isTyping);
        },
        onError: (error, stackTrace) {
          log('Typing status error: $error');
          return const TypingIndicatorState(isTyping: false);
        },
      );
    });
  }
}

