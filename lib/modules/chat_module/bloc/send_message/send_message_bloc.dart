import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/send_message/send_message_event.dart';
import 'package:equatable/equatable.dart';

part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatRepository chatRepository;

  // Positional yerine named parameter kullanıyoruz
  SendMessageBloc({required this.chatRepository}) : super(SendMessageInitial()) {
    on<SendMessageRequested>((event, emit) async {
      emit(SendMessageLoading());
      try {
        await chatRepository.sendMessage(event.receiverUid, event.message);
        emit(SendMessageSuccess());
      } catch (e) {
        emit(SendMessageFailure(error: e.toString()));
      }
    });
  }
}
