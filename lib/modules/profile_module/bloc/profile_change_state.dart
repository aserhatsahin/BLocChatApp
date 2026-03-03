part of 'profile_change_bloc.dart';

abstract class ProfileChangeState extends Equatable {
  const ProfileChangeState();

  @override
  List<Object?> get props => [];
}

final class ProfileChangeInitial extends ProfileChangeState {}

final class ProfileChangeLoading extends ProfileChangeState {}

final class ProfileChangeSuccess extends ProfileChangeState {
  final String message;
  final UserModel? updatedUser; // Yeni alan eklendi

  const ProfileChangeSuccess({required this.message, this.updatedUser});

  @override
  List<Object?> get props => [message, updatedUser];
}

final class ProfileChangeFailure extends ProfileChangeState {
  final String error;

  const ProfileChangeFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
