part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthenticationEvent {
  const SignUpRequested(this.user, this.password);
  final UserModel user;
  final String password;
}

class SignInRequested extends AuthenticationEvent {
  const SignInRequested(this.email, this.password);
  final String email;
  final String password;
}

class LogOutRequested extends AuthenticationEvent {
  const LogOutRequested();
}

class AuthStateChanged extends AuthenticationEvent {
  const AuthStateChanged(this.user);

  final UserModel user;
}
