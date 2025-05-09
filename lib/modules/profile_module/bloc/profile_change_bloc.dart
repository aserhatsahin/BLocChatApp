import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_change_event.dart';
part 'profile_change_state.dart';

class ProfileChangeBloc extends Bloc<ProfileChangeEvent, ProfileChangeState> {
  final UserRepository _userRepository;

  ProfileChangeBloc(UserRepository userRepository)
    : _userRepository = userRepository,
      super(ProfileChangeInitial()) {
    on<UpdateUsernameRequested>((event, emit) async {
      emit(ProfileChangeLoading());
      try {
        log('Updating username for user: ${event.user.uid} to ${event.newUsername}');
        final user = event.user.copyWith(username: event.newUsername);
        await _userRepository.updateUserData(user);
        emit(ProfileChangeSuccess(message: 'Kullanıcı Adı Güncellendi'));
      } catch (e) {
        log('Error updating username: $e');
        emit(ProfileChangeFailure(error: e.toString()));
      }
    });

    on<UpdatePasswordRequested>((event, emit) async {
      emit(ProfileChangeLoading());
      try {
        log('Updating password');
        await _userRepository.updatePassword(event.newPassword);
        emit(ProfileChangeSuccess(message: 'Şifre Güncellendi'));
      } catch (e) {
        log('Error updating password: $e');
        emit(ProfileChangeFailure(error: e.toString()));
      }
    });

    on<UpdateProfilePictureRequested>((event, emit) async {
      emit(ProfileChangeLoading());
      try {
        log('Uploading profile picture for user: ${event.user.uid}');
        final downloadUrl = await _userRepository.uploadPicture(event.filePath, event.user.uid);
        final updatedUser = event.user.copyWith(imageUrl: downloadUrl);
        await _userRepository.updateUserData(updatedUser);
        emit(ProfileChangeSuccess(message: 'Profil Fotoğrafı Güncellendi'));
      } catch (e) {
        log('Error uploading profile picture: $e');
        emit(ProfileChangeFailure(error: e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(ProfileChangeLoading());
      try {
        log('Logging out');
        await _userRepository.logOut();
        emit(ProfileChangeSuccess(message: 'Log out successfully'));
      } catch (e) {
        log('Error logging out: $e');
        emit(ProfileChangeFailure(error: e.toString()));
      }
    });
  }
}
