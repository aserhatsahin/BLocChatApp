import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final UserRepository _userRepository;

  SearchUserBloc(UserRepository userRepository)
    : _userRepository = userRepository,
      super(SearchUserInitial()) {
    on<SearchUserRequested>((event, emit) async {
      if (event.username.isEmpty) {
        emit(SearchUserLoaded(users: []));
        return;
      }

      try {
        emit(SearchUserLoading());

        final users = await _userRepository.searchUsers(event.username);
        log('Fetched users: $users');
        emit(SearchUserLoaded(users: users));
      } catch (e) {
        log('Error fetching users: $e');
        emit(SearchUserFailure());
      }
    });
  }
}
