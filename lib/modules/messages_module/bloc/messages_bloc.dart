import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial()) {
    on<MessagesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
