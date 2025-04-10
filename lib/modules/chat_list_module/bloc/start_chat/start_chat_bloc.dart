import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'start_chat_event.dart';
part 'start_chat_state.dart';

class StartChatBloc extends Bloc<StartChatEvent, StartChatState> {
  final ChatRepository _chatRepository;
  StartChatBloc(ChatRepository chatRepository)
    : _chatRepository = chatRepository,
      super(StartChatInitial()) {
    on<StartChatEvent>((event, emit) {
      on<StartChatRequested>((event, emit) async {
        try {
          emit(StartChatLoading());

          final currentUser = FirebaseAuth.instance.currentUser;

          final chatId = "${currentUser!.uid}-${event.receiverUid}";

          await _chatRepository.createChatIfNotExist(event.receiverUid);

          emit(StartChatSuccess(chatId: chatId));
        } catch (e) {
          emit(StartChatFailure());
        }
      });
    });
  }
}
