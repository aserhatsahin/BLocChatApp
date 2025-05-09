import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'dart:developer';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc(UserRepository userRepository)
    : _userRepository = userRepository,
      super(AuthenticationInitial()) {
    on<SignInRequested>((event, emit) async {
      try {
        emit(AuthenticationLoading());

        await _userRepository.signIn(event.email, event.password);

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          emit(AuthenticationFailure("Kullanıcı bulunamadı"));
          return;
        }
        final uid = currentUser.uid;

        // Firestore’dan kullanıcı verilerini al
        UserModel userModel = await _userRepository.getUserData(uid);
        emit(AuthenticationSuccess(userModel));
      } catch (e) {
        emit(AuthenticationFailure("Giriş yapılamadı: ${e.toString()}"));
      }
    });

    on<SignUpRequested>((event, emit) async {
      try {
        emit(AuthenticationLoading());

        UserModel user = await _userRepository.signUp(event.user, event.password);

        await _userRepository.setUserData(user);

        emit(AuthenticationSuccess(user));
      } catch (e) {
        emit(AuthenticationFailure("Kayıt olunamadı: ${e.toString()}"));
      }
    });

    on<LogOutRequested>((event, emit) async {
      try {
        await _userRepository.logOut();
        emit(AuthenticationEnded());
      } catch (e) {
        emit(AuthenticationFailure("Çıkış yapılamadı: ${e.toString()}"));
      }
    });
  }

  @override
  void onEvent(AuthenticationEvent event) {
    super.onEvent(event);
    log("🔵 EVENT RECEIVED: $event");
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
    log("🔄 STATE CHANGED: $change");
  }
}
