part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object> get props => [];
}

class SearchUserRequested extends SearchUserEvent {
  final String username;

  const SearchUserRequested({required this.username});
  @override
  List<Object> get props => [username];
}
