part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

class AuthenticationFailure extends AuthenticationState {
  const AuthenticationFailure(this.msg);
  final String? msg;
}

class AuthenticationEnded extends AuthenticationState {}
