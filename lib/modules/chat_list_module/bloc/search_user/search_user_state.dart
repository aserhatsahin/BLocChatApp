part of 'search_user_bloc.dart';

abstract class SearchUserState extends Equatable {
  const SearchUserState();

  @override
  List<Object> get props => [];
}

final class SearchUserInitial extends SearchUserState {}

final class SearchUserLoading extends SearchUserState {}

final class SearchUserFailure extends SearchUserState {}

class SearchUserLoaded extends SearchUserState {
  final List<UserModel> users;
  const SearchUserLoaded({required this.users});
  @override
  List<Object> get props => [users];
}
