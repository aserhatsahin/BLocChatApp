part of 'profile_change_bloc.dart';

abstract class ProfileChangeEvent extends Equatable {
  const ProfileChangeEvent();
  @override
  List<Object?> get props => [];
}

class UpdateUsernameRequested extends ProfileChangeEvent {
  final UserModel user;
  final String newUsername;

  const UpdateUsernameRequested({required this.user,required this.newUsername});

  @override
  List<Object?> get props => [user, newUsername];
}

class UpdatePasswordRequested extends ProfileChangeEvent {
  final String newPassword;
  const UpdatePasswordRequested({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class UpdateProfilePictureRequested extends ProfileChangeEvent {
  final UserModel user;
  final String filePath;
  const UpdateProfilePictureRequested({required this.user, required this.filePath});
  @override
  // TODO: implement props
  List<Object?> get props => [user, filePath];
}

class LogoutRequested extends ProfileChangeEvent {
  const LogoutRequested();
}
